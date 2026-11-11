#!/usr/bin/env bash
# bws: the Bitwarden Secrets Manager CLI. Ansible reads platform secrets
# through it, with the Platform reader's token in BWS_ACCESS_TOKEN.
set -euo pipefail
source "$(dirname "$0")/lib.sh"

bws_base="https://github.com/bitwarden/sdk-sm/releases/download/bws-v${BWS_VERSION}"
bws_zip="bws-x86_64-unknown-linux-gnu-${BWS_VERSION}.zip"
download "${bws_base}/${bws_zip}"
download "${bws_base}/bws-sha256-checksums-${BWS_VERSION}.txt"
verify "$(sha_from "bws-sha256-checksums-${BWS_VERSION}.txt" " ${bws_zip}\$")" "$bws_zip"
unzip -q "$bws_zip" bws
install -m 755 bws /usr/local/bin/bws
