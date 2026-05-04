class WecomCli < Formula
  desc "CLI for WeCom (WeChat Work)"
  homepage "https://github.com/WecomTeam/wecom-cli"
  # Upstream does not cut git tags, so we pin to the release commit by `revision`.
  # `version` embeds the same SHA as `<semver>-<gitHead>` so livecheck can match
  # what `npm view @wecom/cli gitHead` reports — see the livecheck block below.
  # On bump: `brew bump-formula-pr --version=X.Y.Z-<sha> --revision=<sha> wecom-cli`
  url "https://github.com/WecomTeam/wecom-cli.git",
      revision: "314ffcdb262ad4db0b93a5ed66deff0d0de259eb"
  version "0.1.7-314ffcdb262ad4db0b93a5ed66deff0d0de259eb"
  license "MIT"
  head "https://github.com/WecomTeam/wecom-cli.git", branch: "main"

  # Upstream does not cut git tags or GitHub releases; the npm registry is the
  # canonical source of truth (every release commit bumps `package.json` in
  # lockstep). `gitHead` is recorded by `npm publish` and matches the release
  # commit, so we combine it with `version` to mirror the formula's format.
  livecheck do
    url "https://registry.npmjs.org/@wecom/cli/latest"
    strategy :json do |json|
      "#{json["version"]}-#{json["gitHead"]}"
    end
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # The binary only reports the SemVer prefix (Cargo.toml's version),
    # not the hyphen-suffixed commit SHA recorded in `version`.
    semver = version.to_s.rpartition("-").first
    assert_match "wecom-cli #{semver}", shell_output("#{bin}/wecom-cli --version")
    assert_match "Usage: wecom-cli", shell_output("#{bin}/wecom-cli --help")
    assert_equal "[]", shell_output("#{bin}/wecom-cli cache status").strip
  end
end
