class CodebuddyCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://cnb.cool/codebuddy/codebuddy-code"
  url "https://registry.npmjs.org/@tencent-ai/codebuddy-code/-/codebuddy-code-1.0.19.tgz"
  sha256 "49193ddc33552500ec493142e17c55a1afdd13b2cdb3fe1d727755aabae8c741"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "196a2d815a1d414038db00ffc286bb63da002ead3af2982676872fffc5942496"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1c15e6465eba18332c2ec29e9cb6417689cebb6838eb58ce864298b4486e3b10"
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
