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
source clusters/_shared/component.sh

cluster=eu1

# Installs a component exactly as Argo CD manages it afterwards
install() {
  local output
  output=$(component_helm_args "$cluster" "$1")
  local args
  mapfile -t args <<<"$output"

  helm upgrade --install "${args[@]}" \
    --kube-context "$cluster" \
    --create-namespace \
    --wait --timeout 10m
}

install networking/cilium
install operations/argo_cd
kubectl --context "$cluster" apply -f "clusters/$cluster/bootstrap/root.yaml"
