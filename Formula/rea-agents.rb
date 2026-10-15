class ReaAgents < Formula
  desc "Reverse engineer anything from your terminal or agent via CLI and MCP"
  homepage "https://github.com/morluto/rea"
  url "https://registry.npmjs.org/rea-agents/-/rea-agents-6.5.0.tgz"
  sha256 "531717a06e92ca651aab52691190f916fac044272c01f875e22c5e293218e699"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "55376455e1d14fb9e49c2fbb1598c390c8b998225108a9bbe38c78bab8e9f785"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "55376455e1d14fb9e49c2fbb1598c390c8b998225108a9bbe38c78bab8e9f785"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0b4607f694815c9b4314dd2b0755461e2e7be9ddb47b9493dcc47d0197637018"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a76fbe74b9ba322159dd462f10ff46989773730ccb1b8642c42608211c37a942"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove prebuilt binaries for unsupported platforms
    rm_r libexec/"lib/node_modules/rea-agents/native/windows"

    # frida's mocha test fixtures ship non-native unixvictim binaries
    rm_r libexec/"lib/node_modules/rea-agents/node_modules/frida/test"

    generate_completions_from_executable(bin/"rea", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rea --version")
  end
end
