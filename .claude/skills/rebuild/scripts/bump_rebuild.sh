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
#   1  usage error / formula file not found / malformed bottle block
#   3  formula has no `bottle do ... end` block (nothing to rebuild)
set -euo pipefail

check_only=0
if [[ "${1:-}" == "--check" ]]
then
  check_only=1
  shift
fi

raw="${1:-}"
if [[ -z "${raw}" ]]
then
  echo "usage: bump_rebuild.sh [--check] <formula-name>" >&2
  exit 1
fi

name="${raw##*/}"  # drop any leading path / tap prefix
name="${name%.rb}" # drop trailing .rb
file="Formula/${name}.rb"

if [[ ! -f "${file}" ]]
then
  echo "error: ${file} not found (run from the tap repository root)" >&2
  exit 1
fi

# Walk the file once. Lines outside the `bottle do ... end` block are kept
# verbatim; lines inside it are dropped, while the current `rebuild` value is
# remembered. A single `rebuild N` line is emitted before the closing `end`.
found=0
inblock=0
cur=0
output=()

while IFS= read -r line || [[ -n "${line}" ]]
do
  if [[ "${found}" -eq 0 && "${line}" == "  bottle do" ]]
  then
    found=1
    inblock=1
    output+=("${line}")
    continue
  fi

  if [[ "${inblock}" -eq 1 && "${line}" == "  end" ]]
  then
    inblock=0
    output+=("    rebuild $((cur + 1))")
    output+=("${line}")
    continue
  fi

  if [[ "${inblock}" -eq 1 ]]
  then
    if [[ "${line}" =~ ^[[:space:]]*rebuild[[:space:]]+([0-9]+) ]]
    then
      cur="${BASH_REMATCH[1]}"
    fi
    continue
  fi

  output+=("${line}")
done <"${file}"

if [[ "${found}" -eq 0 ]]
then
  echo "error: ${file} has no \`bottle do\` block; nothing to rebuild" >&2
  exit 3
fi

if [[ "${inblock}" -eq 1 ]]
then
  echo "error: ${file} has an unterminated \`bottle do\` block" >&2
  exit 1
fi

if [[ "${check_only}" -eq 0 ]]
then
  printf '%s\n' "${output[@]}" >"${file}"
fi

echo "$((cur + 1))"
