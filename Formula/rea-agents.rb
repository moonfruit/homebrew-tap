class ReaAgents < Formula
  desc "Reverse engineer anything from your terminal or agent via CLI and MCP"
  homepage "https://github.com/morluto/rea"
  url "https://registry.npmjs.org/rea-agents/-/rea-agents-6.5.0.tgz"
  sha256 "531717a06e92ca651aab52691190f916fac044272c01f875e22c5e293218e699"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f2d282ec0dfbfc73a34f7ba5b18d32b6098d926a17c836bc8916b7481bebb470"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f2d282ec0dfbfc73a34f7ba5b18d32b6098d926a17c836bc8916b7481bebb470"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ba2b74d9116ec1bc9918e81aa62f738f6c1c29cb1a206dd539ff36f592e679da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "112b113ad86e260b2ee713a570f679fabdf729cff2f5fba4afa6634b8b859e24"
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
