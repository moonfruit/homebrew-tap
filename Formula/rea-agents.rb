class ReaAgents < Formula
  desc "Reverse engineer anything from your terminal or agent via CLI and MCP"
  homepage "https://github.com/morluto/rea"
  url "https://registry.npmjs.org/rea-agents/-/rea-agents-6.8.0.tgz"
  sha256 "8d542ec76a9cb350584b60a6c9c088706ff812d5bb5b094c20c95b6dc25698bb"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2f11e5c093939cef3ef8f04d85c34e8b5db0b3cc73fc14872d3b1b4362317e58"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2f11e5c093939cef3ef8f04d85c34e8b5db0b3cc73fc14872d3b1b4362317e58"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5752ed1d46fcec4b231e8c583bc11860a4158fe3e3c52a8eea784e58ec2ec998"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "278d230c36bd63cfef71b9c06a3c06e00855c2c0fa8a2bd38dcffefd06ac4816"
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
