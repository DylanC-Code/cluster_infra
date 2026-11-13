#!/usr/bin/env bash
# Puts the three Bitwarden machine tokens in the cluster, one Secret each in
# external-secrets, where the stores read them. They are the only secrets
# typed by hand: they are what opens Bitwarden. Each is asked for without
# being shown, and never passed on a command line.
# Find them in the vault: Castor / Infra / Infra/Production/Bootstrap,
#   "eu1 · bws · <environment> reader token (external secrets)"
# Run from the repo root, with the API tunnel open (ktunnel); bootstrap.sh
# calls it too. Rerun it to rotate a token.
set -euo pipefail

cluster=eu1
namespace=external-secrets

# The namespace may not exist yet on a new cluster: Argo CD adopts it later
kubectl --context "$cluster" create namespace "$namespace" \
  --dry-run=client -o yaml | kubectl --context "$cluster" apply -f -

for environment in platform staging prod; do
  read -rsp "Bitwarden token for the $environment store (Enter to keep the current one): " token
  echo
  if [[ -z $token ]]; then
    continue
  fi
  kubectl --context "$cluster" -n "$namespace" create secret generic \
    "bitwarden-$environment-token" --from-file=token=<(printf '%s' "$token") \
    --dry-run=client -o yaml | kubectl --context "$cluster" apply -f -
done
unset token
