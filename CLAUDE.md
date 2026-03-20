# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal Homebrew third-party tap (`moonfruit/tap`) containing Formula and Cask definitions for packages not in the official Homebrew repositories.

## Repository Structure

- `Formula/` — Homebrew formula definitions (Ruby classes inheriting `Formula`)
- `Casks/` — Homebrew cask definitions (for GUI apps and fonts)
- `audit_exceptions/` — JSON files for suppressing specific `brew audit` warnings

## Common Commands

```bash
# Audit a formula or cask for style/correctness issues
brew audit --tap moonfruit/tap
brew audit --formula moonfruit/tap/<name>
brew audit --cask moonfruit/tap/<name>

# Style check (RuboCop)
brew style moonfruit/tap
brew style Formula/<name>.rb

# Test a formula
brew test moonfruit/tap/<name>

# Install from local source
brew install --build-from-source Formula/<name>.rb

# Build bottles (precompiled binaries)
brew install --build-bottle Formula/<name>.rb
brew bottle --root-url "https://ghcr.io/v2/moonfruit/bottle" <name>
```

## Bottle Hosting

Bottles are hosted on GitHub Container Registry under `ghcr.io/v2/moonfruit/bottle`. When updating bottle blocks, use this `root_url`.

## Formula Conventions

- Formulas that conflict with official Homebrew packages use `keg_only :versioned_formula` (e.g., `sing-box-beta`, `openssl@1.0`)
- Go-based formulas use `depends_on "go" => :build` and `std_go_args`
- `livecheck` blocks are used to track upstream releases
- Service blocks define `brew services` integration where applicable
