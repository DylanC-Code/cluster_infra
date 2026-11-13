#!/usr/bin/env bash
# Every check of the repo, the same ones CI runs on each pull request.
# Run from the repo root before pushing: bash tests/run_all.sh
set -uo pipefail

checks=(
  check_layout
  check_dependency_rule
  check_file_length
  check_lint
  check_manifests
)

failed=()
for check in "${checks[@]}"; do
  echo "===== $check"
  bash "tests/$check.sh" || failed+=("$check")
done

echo
if (( ${#failed[@]} > 0 )); then
  echo "Failed: ${failed[*]}"
  exit 1
fi
echo "All checks passed"
