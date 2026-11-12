#!/usr/bin/env bash
# Ansible, ansible-lint and yamllint, in their own virtual environment
# (Ubuntu forbids pip installs into the system Python).
# passlib: lets Ansible hash passwords (password_hash filter).
# The Dockerfile adds /opt/python_tools/bin to PATH.
set -euo pipefail
source "$(dirname "$0")/lib.sh"

VENV=/opt/python_tools

python3 -m venv "$VENV"
"$VENV/bin/pip" install --no-cache-dir --quiet \
  "ansible-core==${ANSIBLE_CORE_VERSION}" \
  "ansible-lint==${ANSIBLE_LINT_VERSION}" \
  "yamllint==${YAMLLINT_VERSION}" \
  "passlib==${PASSLIB_VERSION}"
