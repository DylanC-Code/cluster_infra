#!/usr/bin/env bash
# Kyverno's rules (platform/security/kyverno/config/*_policies.yaml) do
# what they say:
#   - every resource of tests/policies/allowed.yaml passes them all
#   - every resource of tests/policies/refused.yaml breaks at least one
# Both are checked in a test app namespace (tests/policies/values.yaml).
# Run from the repo root: bash tests/check_policies.sh
set -euo pipefail

policies=(platform/security/kyverno/config/*_policies.yaml)
cases=tests/policies
failed=0

# Applies the rules to one case file; prints Kyverno's report
apply() {
  kyverno apply "${policies[@]}" --resource "$cases/$1.yaml" \
    --values-file "$cases/values.yaml" --remove-color 2>&1
}

# How many resources a case file holds
count() {
  grep -c '^kind:' "$cases/$1.yaml"
}

echo "--- allowed"
output=$(apply allowed) || failed=1
passed=$(sed -n 's/^pass: \([0-9]*\).*/\1/p' <<<"$output")
# Every resource must have been checked by at least one rule, else a rule
# that matches nothing would pass this test too
if (( failed == 1 || ${passed:-0} < $(count allowed) )); then
  echo "$output"
  echo "FAIL: $cases/allowed.yaml must pass every rule, each resource checked"
  failed=1
fi

echo "--- refused"
output=$(apply refused) || true
refused=$(grep -oE -e '-> resource [^ ]+ failed' <<<"$output" | sort -u | wc -l)
if (( refused != $(count refused) )); then
  echo "$output"
  echo "FAIL: $refused of the $(count refused) resources of $cases/refused.yaml are refused"
  failed=1
fi

exit "$failed"
