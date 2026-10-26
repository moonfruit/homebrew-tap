class ReaAgents < Formula
  desc "Reverse engineer anything from your terminal or agent via CLI and MCP"
  homepage "https://github.com/morluto/rea"
  url "https://registry.npmjs.org/rea-agents/-/rea-agents-6.8.0.tgz"
  sha256 "8d542ec76a9cb350584b60a6c9c088706ff812d5bb5b094c20c95b6dc25698bb"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f0904c04c8d2ac1ec53da5fd4cbae03af619ba355201b9329b21cd4a05ceb1a0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f0904c04c8d2ac1ec53da5fd4cbae03af619ba355201b9329b21cd4a05ceb1a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "05eaf13fcc1ecad220ab1d1d4d267c8358eaff313c3754860c5950a36c42b533"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b5624aa1ca8e0b70375486f76bbeb515d8b6c1b86fc102c35e0c13803cdd7988"
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
