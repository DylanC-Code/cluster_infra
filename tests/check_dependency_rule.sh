#!/usr/bin/env bash
# platform/ and apps/ never name a cluster, a node or a domain (ADR 0002,
# rule 4): those live only in clusters/<name>/ and in ansible/.
# Run from the repo root: bash tests/check_dependency_rule.sh
set -euo pipefail

# The names to look for come from where they are defined
clusters=$(find clusters -mindepth 1 -maxdepth 1 -type d ! -name '_*' -printf '%f\n')
nodes=$(find ansible/inventories -path '*/host_vars/*.yaml' -printf '%f\n' | sed 's/\.yaml$//')
domains=$(sed -n 's/^ansible_host: [^.]*\.//p' ansible/inventories/*/host_vars/*.yaml)

failed=0
for name in $(printf '%s\n' $clusters $nodes $domains | sort -u); do
  if grep -rnwF --exclude-dir=.git -- "$name" platform apps; then
    echo "FAIL: '$name' named above, in a layer that must stay generic"
    failed=1
  fi
done

exit "$failed"
