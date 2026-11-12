#!/usr/bin/env bash
# The only steps applied by hand on eu1, once its nodes run k3s:
#   1. Cilium: no pod starts without a network plugin, Argo CD included.
#   2. Argo CD.
#   3. The root Application: from then on Argo CD manages everything from
#      Git, Cilium and itself included.
# Run from the repo root, with the API tunnel open (ktunnel):
#   bash clusters/eu1/bootstrap/bootstrap.sh
# Once Argo CD runs, change things through Git, not by rerunning this.
set -euo pipefail

cluster=eu1

# One field of a component's source.yaml
field() {
  sed -n "s/^$2: //p" "platform/$1/source.yaml"
}

# Installs a component the way Argo CD manages it afterwards:
# same release name, chart, version and values files
install() {
  local component=$1
  local name
  name=$(basename "$component")
  local args=(--values "platform/$component/values.yaml")
  local cluster_values="clusters/$cluster/values/$name.yaml"
  if [[ -f $cluster_values ]]; then
    args+=(--values "$cluster_values")
  fi

  helm upgrade --install "${name//_/-}" "$(field "$component" chart)" \
    --kube-context "$cluster" \
    --repo "$(field "$component" repo)" \
    --version "$(field "$component" version)" \
    --namespace "$(field "$component" namespace)" --create-namespace \
    "${args[@]}" \
    --wait --timeout 10m
}

install networking/cilium
install operations/argo_cd
kubectl --context "$cluster" apply -f "clusters/$cluster/bootstrap/root.yaml"
