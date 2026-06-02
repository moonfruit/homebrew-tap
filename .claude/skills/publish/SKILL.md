---
name: publish
description: >-
  Ship an already-edited moonfruit/tap formula or cask end to end: commit the
  working-tree change, push a branch, open a PR, watch CI, and then route by
  artifact type — label a formula PR `pr-pull` (online CI builds bottles, writes
  back the `sha256` lines, and merges), or merge a cask PR directly. If CI fails,
  pull the failed job logs, summarize the root cause, and STOP for the user.
  Use whenever the user runs `/publish <name>` or asks to publish / ship /
  release / open a release PR for a formula or cask in this tap. This assumes the
  file is ALREADY edited (url/version/sha256 in place) — it does NOT bump the
  version itself; for re-bottling the SAME version use the `rebuild` skill.
---

# publish — ship an edited formula or cask through CI

This skill takes a formula or cask whose file you have **already edited**
(new `version`/`url`/`sha256`, or any other change) and drives it through the
tap's release flow. It never edits the package's own content — that is done
before the skill runs. Its job is the mechanical, error-prone part: branch,
commit, push, PR, watch CI, and route correctly afterwards.

The two routes differ because of how the tap's CI is wired (see
`.github/workflows/`):

- **Formula** → bottles. `tests.yml` builds bottles on the PR, but they are only
  published when the PR is labeled `pr-pull`: `publish.yml` then runs
  `brew pr-pull`, which writes the `sha256` lines back into the formula and
  merges to `main`. So a formula is finished by **adding the `pr-pull` label**,
  not by merging it yourself.
- **Cask** → no bottles. Once CI is green there is nothing to write back, so the
  PR is finished by **merging it directly**.

The argument is the package name (e.g. `rmux` for `Formula/rmux.rb`). If no name
was given, ask which package to publish.

## Hard rule

If **any** step fails, **STOP immediately** — do not run later steps — and
report the failure with the relevant output. This skill pushes branches, opens a
real PR, and can merge it; a half-finished run is worse than a clean stop. In
particular, never add `pr-pull` or merge while any check is failing or pending.

## Steps

Run everything from the tap root
(`/opt/homebrew/Library/Taps/moonfruit/homebrew-tap`). Let `<name>` be the
package name.

### 1. Identify the artifact and its change

Determine whether this is a formula or a cask by which file exists:

```bash
ls Formula/<name>.rb 2>/dev/null && echo FORMULA
ls Casks/<name>.rb Casks/**/<name>.rb 2>/dev/null && echo CASK
```

- `Formula/<name>.rb` exists → **formula** route (label `pr-pull`).
- `Casks/<name>.rb` (or under a subdir) exists → **cask** route (direct merge).
- Neither exists → STOP and report (check the name).

Confirm the working tree actually has the change to publish:

```bash
git status --porcelain
```

The target file must appear (as modified `M` or untracked `??`). If the working
tree is clean, STOP — there is nothing to publish; the file must be edited
first. If unrelated files are also dirty, note them and confirm with the user
before continuing — the tap convention is **one package per PR, single commit**.

### 2. Pre-commit checks

Catch anything CI would reject, locally and cheaply, before opening the PR:

```bash
brew style --fix moonfruit/tap/<name>
brew audit --strict --online moonfruit/tap/<name>   # add --new for a brand-new file
```

For a formula you may also run `brew test moonfruit/tap/<name>`, but a
source build can be slow — CI runs it regardless, so skipping it locally is
fine if it is too slow. If `style` or `audit` fails, STOP and report.

### 3. Pick the version and branch

Read the version straight from the (edited) file so the commit and PR title
match what ships:

```bash
brew info --json=v2 moonfruit/tap/<name> | \
  jq -r '(.formulae[0].versions.stable // .casks[0].version)'
```

Call this `<version>`. Choose the branch:

- If you are on `main`, create a fresh branch (it carries the uncommitted change
  with it): `git checkout -b publish-<name>-<version>`.
- If you are already on a feature branch that holds this change (a common
  starting point), stay on it — do not switch.

### 4. Commit

Stage only the target file (plus any required `audit_exceptions/` change), per
the one-package-per-commit convention:

```bash
git add Formula/<name>.rb        # or the Casks/ path
git commit -m "<name> <version>"
```

Use `<name> <version>` for a version bump or new file. For a non-version change
(e.g. fixing a `livecheck` or `uninstall`), use `<name>: <short change>` instead
— that is the tap's message convention.

### 5. Push and open the PR

```bash
git push -u origin <branch>
gh pr create --repo moonfruit/homebrew-tap --base main --head <branch> \
  --title "<name> <version>" \
  --body "Publish \`<name>\` <version>."
```

Capture the PR number (`gh pr view --json number -q .number`).

### 6. Watch CI

```bash
gh pr checks <PR> --watch --interval 30
```

`--watch` blocks until no check is pending. If the shell timeout cuts it off,
just run it again — it resumes from the current state. If it reports "no checks"
right after opening, wait ~20s and retry; checks take a moment to register.

### 7a. CI green → route by artifact

- **Formula** (or a mixed PR that contains any formula): add the label so the
  online bottle pipeline takes over, then report.

  ```bash
  gh pr edit <PR> --add-label pr-pull
  ```

  Tell the user the PR is green and labeled `pr-pull`; `publish.yml` will build
  the multi-platform bottles, write back the `sha256` lines, and merge.

- **Cask**: nothing to write back, so merge directly and report.

  ```bash
  gh pr merge <PR> --squash --delete-branch
  ```

### 7b. CI failed → investigate, then STOP

Do **not** add `pr-pull` and do **not** merge. Find the failed run and pull its
logs so the user gets a real root cause, not just a red X:

```bash
gh pr checks <PR>                       # see which check failed
gh run view <run-id> --log-failed       # run-id from the failed check's URL
```

Read the failed log and summarize for the user:

- which stage broke — `brew test-bot` audit (`--only-tap-syntax`), test
  (`--only-formulae` test step), or bottle build — and on which platform
  (macOS / `ubuntu` arm / x86);
- the specific error lines and your best read of the root cause;
- the PR URL.

Then STOP and ask how they want to proceed. Fixing usually means editing the
file, amending the commit, and `git push --force-with-lease` — which re-triggers
CI; you can re-enter at step 6 once the user has decided.

## Notes

- One package per PR, single commit. Branch `publish-<name>-<version>` when
  starting from `main`; otherwise the current feature branch is fine.
- Formula finishes via the `pr-pull` **label** (CI merges); cask finishes via
  **direct merge**. A mixed formula+cask PR goes the `pr-pull` route, because the
  formula still needs its bottle `sha256` written back.
- This skill never edits the package body and never runs `brew bottle` locally —
  bottles are built only by the online `pr-pull` CI.
- For re-bottling the same version (no content change), use the `rebuild` skill
  instead.
