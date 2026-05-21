#!/usr/bin/env bash
#
# bump_rebuild.sh — inspect or bump a formula's bottle `rebuild` number.
#
# Used by the `rebuild` skill. A Homebrew "rebuild" forces a fresh bottle of
# the *same* version; CI's pr-pull step regenerates the `sha256` lines, so the
# only thing the formula needs to carry into the PR is the bumped `rebuild N`.
#
# Usage:
#   bump_rebuild.sh --check <name>   Validate the formula and print the next
#                                    rebuild number N. Does NOT modify anything.
#   bump_rebuild.sh <name>           Replace the whole `bottle do` block body
#                                    with a single `rebuild N` line, then print N.
#
# N = (current `rebuild` value inside the block, or 0 if absent) + 1.
#
# <name> may be given as "foo", "foo.rb", "Formula/foo.rb" or "moonfruit/tap/foo".
# Run from the tap repository root.
#
# Exit codes:
#   0  ok
#   1  usage error / formula file not found
#   3  formula has no `bottle do ... end` block (nothing to rebuild)
set -euo pipefail

check_only=0
if [[ "${1:-}" == "--check" ]]; then
  check_only=1
  shift
fi

raw="${1:-}"
if [[ -z "$raw" ]]; then
  echo "usage: bump_rebuild.sh [--check] <formula-name>" >&2
  exit 1
fi

name="${raw##*/}"   # drop any leading path / tap prefix
name="${name%.rb}"  # drop trailing .rb
file="Formula/${name}.rb"

if [[ ! -f "$file" ]]; then
  echo "error: $file not found (run from the tap repository root)" >&2
  exit 1
fi

tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT

# Walk the file once: copy every line outside the bottle block verbatim, drop
# every line inside it, and emit a single `rebuild N` line just before the
# block's closing `end`. awk exits 3 if no `bottle do` block was found.
set +e
next="$(
  awk -v tmp="$tmp" '
    BEGIN { inblock = 0; found = 0; cur = 0 }
    !found && /^  bottle do[ \t]*$/ {
      found = 1; inblock = 1
      print > tmp
      next
    }
    inblock && /^  end[ \t]*$/ {
      inblock = 0
      n = cur + 1
      print "    rebuild " n > tmp
      print > tmp
      next
    }
    inblock {
      if ($1 == "rebuild") { cur = $2 + 0 }
      next
    }
    { print > tmp }
    END {
      if (!found) { exit 3 }
      print cur + 1
    }
  ' "$file"
)"
status=$?
set -e

if [[ $status -eq 3 ]]; then
  echo "error: $file has no \`bottle do\` block; nothing to rebuild" >&2
  exit 3
fi
if [[ $status -ne 0 ]]; then
  exit "$status"
fi

if [[ $check_only -eq 0 ]]; then
  cat "$tmp" > "$file"
fi

echo "$next"
