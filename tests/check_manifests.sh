#!/usr/bin/env bash
# Every manifest Argo CD applies renders, and matches its schema:
#   - the bootstrap manifests of each cluster (Argo CD's own resources included)
#   - each platform component, rendered with each cluster's values,
#     and the extra manifests of its config/ folder (kustomize-built
#     when it has a kustomization.yaml)
#   - each app overlay
# Run from the repo root: bash tests/check_manifests.sh
set -euo pipefail
shopt -s nullglob
source clusters/_shared/component.sh

# The Kubernetes version the schemas come from: kubectl's, kept in line with k3s
source .devcontainer/versions.env
kube_version=${KUBECTL_VERSION#v}

# Schemas for custom resources (Argo CD, Cilium...), from a public catalog
crd_schemas='https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/{{.Group}}/{{.ResourceKind}}_{{.ResourceAPIVersion}}.json'

failed=0

# Validates manifests: $1 names them in the output, then the files to
# check (none: read from stdin).
# CustomResourceDefinitions are skipped: no public schema describes them,
# and they come unchanged from the upstream charts.
validate() {
  echo "--- $1"
  shift
  if ! kubeconform -strict -summary \
    -kubernetes-version "$kube_version" \
    -schema-location default -schema-location "$crd_schemas" \
    -skip CustomResourceDefinition \
    "${@:--}"; then
    failed=1
  fi
}

# Renders a component the way Argo CD does: render_component <cluster> <component>
render_component() {
  local output
  output=$(component_helm_args "$1" "$2") || return 1
  local args
  mapfile -t args <<<"$output"
  helm template "${args[@]}" --kube-version "$kube_version"
}

# Validates a component's config/ folder, if it has one, as Argo CD reads
# it: built by kustomize when it holds a kustomization.yaml (only what it
# lists is applied), each file as it is otherwise.
# validate_config <cluster> <component>
validate_config() {
  local config=platform/$2/config
  if [[ -f $config/kustomization.yaml ]]; then
    local rendered
    if rendered=$(kustomize build "$config"); then
      validate "$1: $2 config" <<<"$rendered"
    else
      echo "--- $1: $2 config did not build"
      failed=1
    fi
  elif [[ -d $config ]]; then
    validate "$1: $2 config" "$config"/*.yaml
  fi
}

for cluster_dir in clusters/*/; do
  cluster=$(basename "$cluster_dir")
  # Folders starting with _ hold shared files, not a cluster
  [[ $cluster == _* ]] && continue

  validate "$cluster: bootstrap" "$cluster_dir"bootstrap/*.yaml

  for component in $(cluster_components "$cluster"); do
    if rendered=$(render_component "$cluster" "$component"); then
      validate "$cluster: $component" <<<"$rendered"
    else
      echo "--- $cluster: $component did not render"
      failed=1
    fi
    validate_config "$cluster" "$component"
  done
done

for overlay in apps/*/overlays/*/; do
  if rendered=$(kustomize build "$overlay"); then
    validate "$overlay" <<<"$rendered"
  else
    echo "--- $overlay did not render"
    failed=1
  fi
done

exit "$failed"
