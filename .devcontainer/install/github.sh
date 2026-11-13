#!/usr/bin/env bash
# gh: the GitHub CLI, for pull requests and checks from the terminal.
# Signed in by GH_TOKEN, passed from the host (devcontainer.json runArgs).
set -euo pipefail
source "$(dirname "$0")/lib.sh"

gh_base="https://github.com/cli/cli/releases/download/v${GH_VERSION}"
gh_tar="gh_${GH_VERSION}_linux_amd64.tar.gz"
download "${gh_base}/${gh_tar}"
download "${gh_base}/gh_${GH_VERSION}_checksums.txt"
verify "$(sha_from "gh_${GH_VERSION}_checksums.txt" " ${gh_tar}\$")" "$gh_tar"
tar -xzf "$gh_tar" "gh_${GH_VERSION}_linux_amd64/bin/gh"
install -m 755 "gh_${GH_VERSION}_linux_amd64/bin/gh" /usr/local/bin/gh
