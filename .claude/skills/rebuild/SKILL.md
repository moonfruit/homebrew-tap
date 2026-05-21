---
name: rebuild
description: >-
  Force a fresh bottle rebuild of a moonfruit/tap formula and ship it end to
  end: clears the formula's `bottle do` block down to a single `rebuild N`
  line, then branches, commits, pushes, opens a PR, and labels it `pr-pull`
  once CI passes. Use whenever the user invokes `/rebuild <formula>` or asks to
  rebuild / re-bottle / force a bottle rebuild of a formula in this tap. This
  is for re-bottling the SAME version (e.g. after a dependency or toolchain
  change) — NOT for upgrading a formula to a new version.
---

# rebuild — bump a formula's bottle rebuild number

A Homebrew *rebuild* produces a fresh bottle of the **same** formula version.
The online `pr-pull` CI rebuilds the bottle and writes back the `sha256` lines,
so the only change this skill makes to the formula is replacing the entire
`bottle do` block body with a single `rebuild N` line. Example end state
(shown dedented; in a real formula the block is indented two spaces):

```ruby
bottle do
  rebuild 1
end
```

The argument to this skill is the formula name (e.g. `xxx` for
`Formula/xxx.rb`). If no name was given, ask the user which formula to rebuild.

The helper script `bump_rebuild.sh` (in this skill's `scripts/` directory) does
the formula parsing and rewrite deterministically — use it rather than editing
the `bottle do` block by hand.

## Hard rule

If **any** step below fails, **STOP immediately** — do not run later steps —
and report the failure to the user with the relevant output. This skill pushes
branches and opens a real PR; a half-finished run is worse than a clean stop.

## Steps

Run everything from the tap repository root
(`/opt/homebrew/Library/Taps/moonfruit/homebrew-tap`). Let `<name>` be the
formula name and `<N>` the new rebuild number.

### 1. Preflight

- Confirm the working tree is clean: `git status --porcelain` must be empty.
  If it is dirty, STOP and tell the user to commit or stash first.
- Sync `main`: `git checkout main && git pull --ff-only`. If the pull fails,
  STOP and report — the user's local `main` needs attention first.

### 2. Compute the rebuild number

```bash
.claude/skills/rebuild/scripts/bump_rebuild.sh --check <name>
```

This prints `<N>` and does **not** modify anything. Handle non-zero exits:

- **exit 3** — the formula has no `bottle do` block. STOP and report:
  there is nothing to rebuild. Do not create a branch.
- **exit 1** — the formula file was not found (check the name). STOP and report.

### 3. Create the branch

```bash
git checkout -b rebuild-<name>-<N>
```

### 4. Rewrite the bottle block

```bash
.claude/skills/rebuild/scripts/bump_rebuild.sh <name>
```

This replaces the whole `bottle do` block body with `rebuild <N>` and prints
`<N>` again (confirm it matches step 2). Then verify:

- `git diff` shows changes **only** in `Formula/<name>.rb`, and only inside the
  `bottle do` block — the block body collapses to one `rebuild <N>` line.
- `brew style Formula/<name>.rb` passes (run `brew style --fix` if needed).

If the diff touches anything else, STOP and report.

### 5. Commit

```bash
git add Formula/<name>.rb
git commit -m "<name>: rebuild <N>"
```

Stage only `Formula/<name>.rb` — keep the commit to that single file, per the
tap's one-formula-per-commit convention.

### 6. Push

```bash
git push -u origin rebuild-<name>-<N>
```

### 7. Open the PR

```bash
gh pr create --repo moonfruit/homebrew-tap --base main \
  --head rebuild-<name>-<N> \
  --title "<name>: rebuild <N>" \
  --body "Force a fresh bottle rebuild (\`rebuild <N>\`) of the current version."
```

Capture the PR number from the URL `gh` prints (or `gh pr view --json number`).

### 8. Monitor CI, then label

Wait for every check to finish:

```bash
gh pr checks <PR> --watch --interval 30
```

`--watch` blocks until no check is pending. If the command is cut off by the
shell timeout before checks finish, simply run it again — it resumes from the
current state. (If it reports "no checks" right after the PR is opened, wait
~20s and retry; checks take a moment to register.)

- **All checks pass** (`gh pr checks` exits 0): add the label so the online
  bottle pipeline takes over:

  ```bash
  gh pr edit <PR> --add-label pr-pull
  ```

  Then tell the user the PR is green and labeled `pr-pull`; the `pr-pull` CI
  will build the multi-platform bottles, write back the `sha256` lines, and
  merge the PR.

- **Any check fails or errors**: do **NOT** add the `pr-pull` label. Report
  which checks failed (include `gh pr checks <PR>` output and the PR URL) and
  ask the user how they want to proceed.

## Notes

- One formula per PR, single commit — this skill rebuilds exactly one formula.
- Branch name is always `rebuild-<name>-<N>`; commit and PR title are always
  `<name>: rebuild <N>`.
- The skill never edits the `bottle do` block by hand and never runs
  `brew bottle` locally — bottles are built only by the online `pr-pull` CI.
