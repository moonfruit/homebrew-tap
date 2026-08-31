class WecomCli < Formula
  desc "CLI for WeCom (WeChat Work)"
  homepage "https://github.com/WecomTeam/wecom-cli"
  # Upstream does not cut git tags, so we pin to the release commit by `revision`.
  # Release commits are titled `chore(release): v<version>` and bump the Cargo
  # workspace version in lockstep with the npm package — see the livecheck block.
  # On bump: `brew bump-formula-pr --version=X.Y.Z --revision=<sha> wecom-cli`
  url "https://github.com/WecomTeam/wecom-cli.git",
      revision: "78c514b2afee7c0d3d7be715628478421f37ee63"
  version "1.2.0"
  license "MIT"
  head "https://github.com/WecomTeam/wecom-cli.git", branch: "main"

  # Upstream does not cut git tags or GitHub releases; the npm registry is the
  # canonical source of truth, as every release commit publishes `@wecom/cli`
  # and bumps `Cargo.toml` to the same version.
  livecheck do
    url "https://registry.npmjs.org/@wecom/cli/-/cli-#{version}.tgz"
  end

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "63dbd3ca441f46be67819372397bc937dce603e85956da88d472533c09ec8ba2"
    sha256 cellar: :any,                 arm64_linux:  "91a62abd52eb69554a073f2fd50725b628ad27d907fd91ae0746bb357669c0f4"
    sha256 cellar: :any,                 x86_64_linux: "7c5b2e30d5f8996d4b56d7eab83da1d8613405d25c2505d34221d7bf684fde3a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/wecom-cli")
  end

  test do
    assert_match "wecom-cli #{version}", shell_output("#{bin}/wecom-cli --version")

    # Every other subcommand (`--help` included) resolves the service catalog
    # from WeCom's servers before it runs, so `cache status` on a pristine
    # cache is the only offline-deterministic behaviour left to assert.
    assert_equal "[]", shell_output("#{bin}/wecom-cli cache status").strip
  end
end
