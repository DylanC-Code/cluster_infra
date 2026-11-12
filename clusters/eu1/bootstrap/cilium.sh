#!/usr/bin/env bash
# Installs Cilium before anything else: without a network plugin no pod
# starts, Argo CD included. Argo CD adopts this release later (same name,
# namespace and values files).
# Run from the repo root, with the API tunnel open (ktunnel):
#   bash clusters/eu1/bootstrap/cilium.sh
set -euo pipefail

component=platform/networking/cilium
version=$(sed -n 's/^# chart-version: //p' "$component/values.yaml")

helm repo add cilium https://helm.cilium.io --force-update >/dev/null
helm upgrade --install cilium cilium/cilium \
  --kube-context eu1 \
  --version "$version" \
  --namespace kube-system \
  --values "$component/values.yaml" \
  --values clusters/eu1/values/cilium.yaml \
  --wait --timeout 10m
