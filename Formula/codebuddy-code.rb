class CodebuddyCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://cnb.cool/codebuddy/codebuddy-code"
  url "https://registry.npmjs.org/@tencent-ai/codebuddy-code/-/codebuddy-code-1.0.8.tgz"
  sha256 "e26eb244b7b44548ea3f60df221ecfb84f31831b248f6d50e20cb614144a9b42"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1ffae221913879a1d4a60f532951a4169a8f9787ae245680e3a57c754d70050"
    sha256 cellar: :any_skip_relocation, ventura:       "3ae5912e158c6aeb06f0559b4060521d32f0d3d52797c5005736d5c31e4049f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbdb0508b5f7dff7068347e30498aa1fc3c9f7a181803c1cb7df73a86b1cd505"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codebuddy --version")
    assert_match "No MCP servers configured.", shell_output("#{bin}/codebuddy mcp list")
  end
end
