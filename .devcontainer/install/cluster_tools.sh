#!/usr/bin/env bash
# Cilium CLI (network checks) and k3d (throwaway test clusters in Docker).
set -euo pipefail
source "$(dirname "$0")/lib.sh"

# ---------- Cilium CLI ----------
cil_base="https://github.com/cilium/cilium-cli/releases/download/${CILIUM_CLI_VERSION}"
download "${cil_base}/cilium-linux-amd64.tar.gz"
download "${cil_base}/cilium-linux-amd64.tar.gz.sha256sum"
verify "$(awk '{print $1}' cilium-linux-amd64.tar.gz.sha256sum)" cilium-linux-amd64.tar.gz
tar -xzf cilium-linux-amd64.tar.gz -C /usr/local/bin cilium

# ---------- k3d ----------
k3d_base="https://github.com/k3d-io/k3d/releases/download/${K3D_VERSION}"
download "${k3d_base}/k3d-linux-amd64"
download "${k3d_base}/checksums.txt"
verify "$(sha_from checksums.txt "/k3d-linux-amd64\$")" k3d-linux-amd64
install -m 755 k3d-linux-amd64 /usr/local/bin/k3d
