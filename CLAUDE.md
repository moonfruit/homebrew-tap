# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal Homebrew third-party tap (`moonfruit/tap`) containing Formula and Cask definitions for packages not in the official Homebrew repositories.

## Repository Structure

- `Formula/` — Homebrew formula definitions (Ruby classes inheriting `Formula`)
- `Casks/` — Homebrew cask definitions (for GUI apps and fonts)
- `audit_exceptions/` — JSON files suppressing specific `brew audit` warnings
  - `github_prerelease_allowlist.json` — JSON array of formula/cask names allowed to track prereleases
  - `flat_namespace_allowlist.json` — JSON object `{ "<name>": "any" | ["dylib", ...] }` for casks with non-relocatable Mach-O

## Reference Implementations

When writing or fixing formulae/casks, consult real examples in the official taps before guessing:

- **Formula 实现样例**：`$(brew --prefix)/Library/Taps/homebrew/homebrew-core/Formula/`
  - 按首字母分子目录，例如 `Formula/g/go.rb`、`Formula/o/openssl@3.rb`
  - Go 项目模式参考 `gh.rb`、`fzf.rb`；带 service 的参考 `redis.rb`、`postgresql@*.rb`；keg_only 版本化参考 `openssl@3.rb`、`python@3.*.rb`
- **Cask 实现样例**：`$(brew --prefix)/Library/Taps/homebrew/homebrew-cask/Casks/`
  - 同样按首字母分子目录，字体在 `Casks/font/font-*/`，例如 `font/font-j/font-jetbrains-mono.rb`
  - `pkg` 安装参考已有的 `*.pkg` cask；带 `quit`/`login_item`/`pkgutil` uninstall 的样例多见于 `Casks/s/`
- **brew 自身行为/DSL 定义**：`$(brew --prefix)/Library/Homebrew/`
  - Formula DSL：`formula.rb`、`formula_installer.rb`
  - Cask DSL：`cask/dsl.rb`、`cask/artifact/*.rb`（`pkg.rb`、`app.rb`、`zap.rb` 等）
  - Livecheck 策略：`livecheck/strategy/*.rb`
  - Audit 规则：`formula_auditor.rb`、`cask/audit.rb`（用于理解 audit 报错根因）
  - 直接 `rg` 搜索符号，例如 `rg "def std_go_args" $(brew --prefix)/Library/Homebrew`

不要把这些路径用 Write 写改——它们是只读的官方代码，只用 Read/Grep 查阅。

## Common Commands

```bash
# Audit
brew audit --tap moonfruit/tap
brew audit --formula moonfruit/tap/<name>
brew audit --cask moonfruit/tap/<name>
brew audit --new moonfruit/tap/<name>          # stricter rules for first submission

# Style (RuboCop) — fix is safe
brew style --fix moonfruit/tap
brew style --fix Formula/<name>.rb

# Test
brew test moonfruit/tap/<name>

# Livecheck — verify upstream regex
brew livecheck moonfruit/tap/<name>
brew livecheck --tap moonfruit/tap

# Install from local source
brew install --build-from-source Formula/<name>.rb

# Bump helpers
brew bump-formula-pr --no-fork --no-browse --tap moonfruit/tap <name>
brew bump-cask-pr   --no-fork --no-browse --tap moonfruit/tap <name>
```

## Bottle Hosting

Bottles are hosted on GitHub Container Registry under `ghcr.io/v2/moonfruit/bottle` 并由线上 CI 构建发布，**不要在本地手工跑 `brew bottle`**。线上 `pr-pull` 流程会自动产出多平台 bottle 并把 `sha256` 行回写进 Formula。

## Formula Conventions

- Versioned/conflicting formulae use `keg_only :versioned_formula` (see `openssl@1.0.rb`, `sing-box-beta.rb`, `gwt@2.*`)
- Go formulae use `depends_on "go" => :build` + `std_go_args(output: ..., ldflags: "-s -w")`；多命令仓库循环编译 `cmd/*`（见 `gotools.rb`）
- `livecheck do ... end` 必备；`regex(...)` 参考 homebrew-core 同类项目
- `service do` 块用于 `brew services`（见 `sing-box-beta.rb`、`sing-box-ref1nd.rb`）
- 不手工编辑 `bottle do` 块 — 由线上 CI 在 `pr-pull` 阶段写入

## Cask Conventions

- 双架构以 `arch arm: "...", intel: "..."` + `sha256 arm:, intel:` 表达；URL 中用 `#{arch}`
- 字体 Cask 命名为 `font-*`，参考 `Casks/font-source-han-*`、`Casks/font-pinyin-*`
- `.pkg` 安装必须配 `uninstall pkgutil:`；带后台进程再加 `quit:`，登录项加 `login_item:`（见 `sfm@alpha.rb`）
- `zap trash: [...]` 列出 `~/Library/...` 残留路径
- `verified:` 用于非 GitHub releases 域或自定义 URL；`url "..." , verified: "github.com/<org>/<repo>/"` 是常见写法

## Pre-commit Checklist

提交前对改动文件依次跑：

```bash
brew style --fix moonfruit/tap/<name>
brew audit --strict --online moonfruit/tap/<name>
brew livecheck moonfruit/tap/<name>      # 如改了 livecheck 或版本
brew test moonfruit/tap/<name>           # formula 才有
```

## Release Workflow

### PR 与提交粒度

- **一个 PR 默认只动一个 formula 或 cask**；只在有强相关性时才允许多个，例如：
  - 依赖链一起升：`tongsuo` 与依赖它的 `tscurl`
  - 同一软件的多个版本/配置：`gwt@2.4`/`gwt@2.5`/`gwt@2.6`/`gwt@2.7`、`wlp-webprofile8` 与 `wlp-webprofile10`
- **每个 formula / cask 在 PR 内保持单一提交**：一个 PR 里如果同时改了 N 个 formula/cask，就有且只有 N 个提交，每个提交只动一个文件（外加可能的 `audit_exceptions/` 同步修改）
- 多次返工用 `git commit --amend`（单提交时）或 `git rebase -i`（多提交时挑对应提交 squash），再 `git push --force-with-lease`
- 提交消息：单升级写 `<name> <version>`；其它修改写 `<name>: <change>`

### Formula 升级 / 新增

线上 CI 负责构建 bottle，所以 Formula 走 `pr-pull` 流程：

1. 改 Formula（版本号、`url`、`sha256`、依赖等）
2. `git commit`（每个 formula 一个提交）
3. 返工时按上节规则 squash，保持每个 formula 仍是单一提交
4. `git push`（首次）或 `git push --force-with-lease`（amend/rebase 后）
5. 开 PR，等待 CI 完成 audit/test 与多平台 bottle 构建
6. Review 通过后给 PR 打上 `pr-pull` 标签
7. CI 检测到 `pr-pull` 标签，自动把 bottle 上传到 `ghcr.io/v2/moonfruit/bottle`，把 `sha256` 行回写进对应 Formula 并合并 PR

### Cask 升级 / 新增

Cask 不产 bottle，流程更短：

1. 改 Cask（`version`、`sha256`、URL、`uninstall`/`zap` 等）
2. `git commit`（每个 cask 一个提交）
3. 返工时 squash，保持每个 cask 单一提交
4. `git push` 或 `git push --force-with-lease`
5. 开 PR，等待 CI 完成 audit
6. Review 通过后直接合并 PR（无需 `pr-pull` 标签）

### 同 PR 内 Formula + Cask 混合

只有在强相关时才这样做；这种 PR 仍按 Formula 流程走 `pr-pull`（因为有 Formula 需要回写 bottle sha256），不要为了 Cask 的"直接合并"流程把它从 PR 里拆出去。
