class CodebuddyCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://cnb.cool/codebuddy/codebuddy-code"
  url "https://registry.npmjs.org/@tencent-ai/codebuddy-code/-/codebuddy-code-1.0.17.tgz"
  sha256 "5ecf492c97387924ee5deda3b44be7f8c09b7ddf9033111bcbbc791d657937c1"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eaf7d3f673a6c2024cb1c9ef13c654cacdd6260a5ad98541aaa359ca568b6720"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80800864a7948161d3216e3f0429efc54784dc2bff26f7a91feaff15271ea6e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "922465863d350cc19534acfc20badfab3dc1fada55485b87f84d226778c401f5"
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
