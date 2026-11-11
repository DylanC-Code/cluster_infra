#!/usr/bin/env bash
# kubeconform (manifest validation) and the Kyverno CLI (policy tests).
# Used by the CI architecture checks, and locally before pushing.
set -euo pipefail
source "$(dirname "$0")/lib.sh"

# ---------- kubeconform ----------
kc_base="https://github.com/yannh/kubeconform/releases/download/${KUBECONFORM_VERSION}"
download "${kc_base}/kubeconform-linux-amd64.tar.gz"
download "${kc_base}/CHECKSUMS"
verify "$(sha_from CHECKSUMS " kubeconform-linux-amd64.tar.gz\$")" kubeconform-linux-amd64.tar.gz
tar -xzf kubeconform-linux-amd64.tar.gz kubeconform
install -m 755 kubeconform /usr/local/bin/kubeconform

# ---------- Kyverno CLI ----------
ky_base="https://github.com/kyverno/kyverno/releases/download/${KYVERNO_VERSION}"
ky_tar="kyverno-cli_${KYVERNO_VERSION}_linux_x86_64.tar.gz"
download "${ky_base}/${ky_tar}"
download "${ky_base}/checksums.txt"
verify "$(sha_from checksums.txt " ${ky_tar}\$")" "$ky_tar"
tar -xzf "$ky_tar" kyverno
install -m 755 kyverno /usr/local/bin/kyverno
