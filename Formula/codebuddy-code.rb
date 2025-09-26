class CodebuddyCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://cnb.cool/codebuddy/codebuddy-code"
  url "https://registry.npmjs.org/@tencent-ai/codebuddy-code/-/codebuddy-code-1.3.0.tgz"
  sha256 "4595a11e4f8f71ee911c0e45e719cceb33dbb4aa479c8b582df2f0d7a1f77b09"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "0afcf4fcb3c6f3c3015d7ae6fe6f561a0c303da8c26f579a2cd544e4f98c9bba"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2f5450f5d321df8861c8b4e1b21934e1371b73ccc3959f83eb0f2aca5923ed91"
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
