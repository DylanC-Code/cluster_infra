#!/usr/bin/env bash
# kubectl, Helm and Kustomize: talking to the cluster and rendering manifests.
set -euo pipefail
source "$(dirname "$0")/lib.sh"

# ---------- kubectl ----------
download "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
download "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl.sha256"
verify "$(cat kubectl.sha256)" kubectl
install -m 755 kubectl /usr/local/bin/kubectl

# ---------- Helm ----------
helm_tar="helm-${HELM_VERSION}-linux-amd64.tar.gz"
download "https://get.helm.sh/${helm_tar}"
download "https://get.helm.sh/${helm_tar}.sha256sum"
verify "$(awk '{print $1}' "${helm_tar}.sha256sum")" "$helm_tar"
tar -xzf "$helm_tar"
install -m 755 linux-amd64/helm /usr/local/bin/helm

# ---------- Kustomize ----------
kz_base="https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2F${KUSTOMIZE_VERSION}"
kz_tar="kustomize_${KUSTOMIZE_VERSION}_linux_amd64.tar.gz"
download "${kz_base}/${kz_tar}"
download "${kz_base}/checksums.txt"
verify "$(sha_from checksums.txt " ${kz_tar}\$")" "$kz_tar"
tar -xzf "$kz_tar" kustomize
install -m 755 kustomize /usr/local/bin/kustomize
