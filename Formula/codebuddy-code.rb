class CodebuddyCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://cnb.cool/codebuddy/codebuddy-code"
  url "https://registry.npmjs.org/@tencent-ai/codebuddy-code/-/codebuddy-code-1.3.0.tgz"
  sha256 "4595a11e4f8f71ee911c0e45e719cceb33dbb4aa479c8b582df2f0d7a1f77b09"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any,                 arm64_tahoe:  "bdc4625623f4ebb2815fb33ef75ef588259c805525ca8a70715ddb2ff2a94fb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "cffcf05a02880fe8fcbedb5564f4a634632b2c37cabe70dcda99cd01f6dbddf5"
  end

  depends_on "node"
  depends_on "pcre2"

  def install
    system "npm", "install", *std_npm_args
    rm(Dir[libexec/"**/x64-darwin/**"]) if OS.mac? && Hardware::CPU.arm?
    rm(Dir[libexec/"**/arm64-linux/**"]) if OS.linux? && Hardware::CPU.intel?
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codebuddy --version")
    assert_match "No MCP servers configured.", shell_output("#{bin}/codebuddy mcp list")
  end
end
