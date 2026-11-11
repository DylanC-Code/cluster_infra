#!/usr/bin/env bash
# Runs at every container start.
# Links the repo's Kubernetes shortcuts into ~/.shellrc.d,
# which the dotfiles source in every new shell (bash or zsh).
set -euo pipefail

WORKSPACE="$1"
DROP_DIR="$HOME/.shellrc.d"

mkdir -p "$DROP_DIR"
ln -sfn "$WORKSPACE/.devcontainer/shell/k8s_aliases.sh" "$DROP_DIR/k8s_aliases.sh"
