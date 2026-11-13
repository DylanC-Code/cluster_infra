# How a platform component is installed on a cluster: the Helm release,
# chart, version, namespace and values files the platform ApplicationSet
# uses (ADR 0004). Sourced, from the repo root, by
# clusters/<name>/bootstrap/bootstrap.sh and tests/check_manifests.sh.

# The components a cluster runs, one per line: cluster_components <cluster>
cluster_components() {
  sed -n 's/^- component: //p' "clusters/$1/platform.yaml"
}

# One field of a component's source.yaml: component_field <component> <field>
component_field() {
  sed -n "s/^$2: //p" "platform/$1/source.yaml"
}

# Helm arguments for a component on a cluster, one per line, release and
# chart first: component_helm_args <cluster> <component>
component_helm_args() {
  local cluster=$1 component=$2
  if [[ ! -f platform/$component/source.yaml ]]; then
    echo "platform/$component/source.yaml not found" >&2
    return 1
  fi

  local name
  name=$(basename "$component")
  printf '%s\n' \
    "${name//_/-}" "$(component_field "$component" chart)" \
    --repo "$(component_field "$component" repo)" \
    --version "$(component_field "$component" version)" \
    --namespace "$(component_field "$component" namespace)" \
    --values "platform/$component/values.yaml"

  local cluster_values="clusters/$cluster/values/$name.yaml"
  if [[ -f $cluster_values ]]; then
    printf '%s\n' --values "$cluster_values"
  fi
}
