#!/usr/bin/env bash
# YAML style for the whole repo, then Ansible best practices.
# Run from the repo root: bash tests/check_lint.sh
set -euo pipefail

echo "--- yamllint"
yamllint --strict .

echo "--- ansible-lint"
# Installs the collections from requirements.yml by itself
(cd ansible && ansible-lint)
