#!/usr/bin/env bash
# The repo keeps its shape (ADR 0002, 0004):
#   - platform/ has only the five categories, each component its contract
#   - each app and each cluster has exactly its contract
#   - every line of platform.yaml, apps.yaml and every values file points
#     to something that exists, and every app size is in the size table
#   - names are snake_case
#   - nothing sits outside the repo's known top-level folders and files
# Run from the repo root: bash tests/check_layout.sh
set -euo pipefail
shopt -s nullglob

failed=0
fail() {
  echo "FAIL: $*"
  failed=1
}

# Fails unless folder $1 holds exactly the entries $2 requires,
# plus any entry $3 allows
check_contract() {
  local dir=$1 required=$2 optional=${3:-}
  local entry
  for entry in $required; do
    [[ -e $dir/$entry ]] || fail "$dir: missing $entry"
  done
  for entry in "$dir"/* "$dir"/.[!.]*; do
    entry=$(basename "$entry")
    [[ " $required $optional " == *" $entry "* ]] || fail "$dir: unexpected $entry"
  done
}

# ---------- platform/ ----------
categories="networking security data observability operations"
for dir in platform/*/; do
  category=$(basename "$dir")
  [[ " $categories " == *" $category "* ]] || fail "platform/$category: not one of: $categories"
  for component in "$dir"*/; do
    check_contract "${component%/}" "README.md source.yaml values.yaml" "config"
    [[ -f ${component}source.yaml ]] || continue
    fields=$(sed -n 's/^\([a-z_]*\):.*/\1/p' "${component}source.yaml" | sort | tr '\n' ' ')
    [[ $fields == "chart namespace repo version " ]] \
      || fail "${component}source.yaml: needs exactly repo, chart, version, namespace"
  done
done

# ---------- apps/ ----------
for app in apps/*/; do
  [[ $(basename "$app") == _* ]] && continue
  check_contract "${app%/}" "README.md base overlays"
  check_contract "${app}overlays" "staging prod"
done

# ---------- clusters/ ----------
# The app sizes, read from the table they are defined in
sizes=$(sed -n 's/^ *"\([a-z]*\)": *{"cpu".*/\1/p' \
  platform/security/kyverno/config/generating_policies.yaml | tr '\n' ' ')
for cluster_dir in clusters/*/; do
  cluster=$(basename "$cluster_dir")
  [[ $cluster == _* ]] && continue
  check_contract "${cluster_dir%/}" "README.md bootstrap platform.yaml apps.yaml" "values"

  listed=$(sed -n 's/^- component: //p' "${cluster_dir}platform.yaml")
  for component in $listed; do
    [[ -d platform/$component ]] || fail "${cluster_dir}platform.yaml: no platform/$component"
  done
  for values in "${cluster_dir}"values/*.yaml; do
    name=$(basename "$values" .yaml)
    grep -qx ".*/$name" <<<"$listed" || fail "$values: $name is not in ${cluster_dir}platform.yaml"
  done
  while read -r app env; do
    [[ -d apps/$app/overlays/$env ]] || fail "${cluster_dir}apps.yaml: no apps/$app/overlays/$env"
  done < <(paste -d' ' <(sed -n 's/^- app: //p' "${cluster_dir}apps.yaml") \
                       <(sed -n 's/^ *env: //p' "${cluster_dir}apps.yaml"))
  for size in $(sed -n 's/^ *size: //p' "${cluster_dir}apps.yaml"); do
    [[ " $sizes " == *" $size "* ]] || fail "${cluster_dir}apps.yaml: size $size is not one of: $sizes"
  done
done

# ---------- Top level: only the known folders and files ----------
# A typo in a path (latform/...) would otherwise escape every check above
top_level=".devcontainer .editorconfig .github .gitignore .yamllint.yaml README.md
  ansible apps clusters docs platform runbooks tests"
while read -r entry; do
  [[ " ${top_level//$'\n'/ } " == *" $entry "* ]] || fail "$entry: not a known top-level folder or file"
done < <(git ls-files --cached --others --exclude-standard | cut -d/ -f1 | sort -u)

# ---------- Names: snake_case files and folders ----------
# Dot files and the names tools impose (README.md, Kubernetes manifests'
# own names inside files) are not concerned
while read -r path; do
  for part in ${path//\// }; do
    [[ $part == .* || $part == README.md ]] && continue
    [[ $part =~ ^[a-z0-9_.]+$ ]] || fail "$path: '$part' is not snake_case"
  done
done < <(git ls-files --cached --others --exclude-standard -- \
  ansible apps clusters docs platform runbooks tests | sort -u)

exit "$failed"
