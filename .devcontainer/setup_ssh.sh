#!/usr/bin/env bash
# Runs at every container start.
# Links the host's SSH config (read-only mount) into ~/.ssh,
# and keeps known_hosts and multiplexing sockets writable here.
set -euo pipefail

HOST_SSH="$HOME/.ssh_host"
SSH_DIR="$HOME/.ssh"

mkdir -p "$SSH_DIR/sockets"
chmod 700 "$SSH_DIR" "$SSH_DIR/sockets"

ln -sfn "$HOST_SSH/config" "$SSH_DIR/config"
ln -sfn "$HOST_SSH/config.d" "$SSH_DIR/config.d"

for pub in "$HOST_SSH"/*.pub; do
  ln -sfn "$pub" "$SSH_DIR/$(basename "$pub")"
done

# Copied once, so accept-new can add entries inside the container
if [ -f "$HOST_SSH/known_hosts" ] && [ ! -f "$SSH_DIR/known_hosts" ]; then
  cp "$HOST_SSH/known_hosts" "$SSH_DIR/known_hosts"
  chmod 600 "$SSH_DIR/known_hosts"
fi