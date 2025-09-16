class CodebuddyCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://cnb.cool/codebuddy/codebuddy-code"
  url "https://registry.npmjs.org/@tencent-ai/codebuddy-code/-/codebuddy-code-1.0.19.tgz"
  sha256 "49193ddc33552500ec493142e17c55a1afdd13b2cdb3fe1d727755aabae8c741"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "f5d7e5ebc82e7ce2391c2e18743526c5de3621f3628e7a50eec382e039323d9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e76951d49411e65c5343fee8f51dca95cd0a0ac10fa4648581546ea44bba13b5"
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
