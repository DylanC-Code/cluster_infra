#!/usr/bin/env bash
# No file over 150 lines (ADR 0002, rule 10): split it by concept instead.
# Lock files are generated, so they are not concerned.
# Run from the repo root: bash tests/check_file_length.sh
set -euo pipefail

max_lines=150
failed=0

while read -r path; do
  [[ -f $path ]] || continue
  lines=$(wc -l <"$path")
  if (( lines > max_lines )); then
    echo "FAIL: $path has $lines lines (max $max_lines)"
    failed=1
  fi
done < <(git ls-files --cached --others --exclude-standard | grep -v -e '\.lock$' -e '-lock\.json$')

exit "$failed"
