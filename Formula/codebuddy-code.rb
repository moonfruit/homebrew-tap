class CodebuddyCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://cnb.cool/codebuddy/codebuddy-code"
  url "https://registry.npmjs.org/@tencent-ai/codebuddy-code/-/codebuddy-code-1.0.17.tgz"
  sha256 "5ecf492c97387924ee5deda3b44be7f8c09b7ddf9033111bcbbc791d657937c1"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "84f680d6a369d80739d4ff9dce456be540b03200e31e9a8ef36b72f45400c300"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc9b582ff4bb9918b4dfdb8ed720b8bb23988f2ddba742babab6e5c1cfa36975"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07220d134c9f75d8548c75d2a90a2e112fa82f47e45e021c2b2a9d0b5fa27570"
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
