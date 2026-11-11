#!/usr/bin/env bash
# Shared helpers for the install scripts: download, then verify a checksum.
set -euo pipefail

# shellcheck source=/dev/null
source /tmp/devcontainer/versions.env

WORK_DIR="$(mktemp -d)"
trap 'rm -rf "$WORK_DIR"' EXIT
cd "$WORK_DIR"

# download <url>: saves the file under its own name in WORK_DIR
download() {
  curl -fsSLO "$1"
}

# verify <expected_sha256> <file>: stops the build on a mismatch
verify() {
  echo "$1  $2" | sha256sum --check --strict
}

# sha_from <checksums_file> <pattern>: the hash on the line matching pattern
sha_from() {
  grep -E "$2" "$1" | awk '{print $1}' | head -1
}
