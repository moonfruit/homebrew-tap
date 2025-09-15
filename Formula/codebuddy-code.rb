class CodebuddyCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://cnb.cool/codebuddy/codebuddy-code"
  url "https://registry.npmjs.org/@tencent-ai/codebuddy-code/-/codebuddy-code-1.0.14.tgz"
  sha256 "a9d83907f94ddbd482e631b2644ec3c6088ecfd7dc53ea55d47378afb61f156a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4147f26f41aac8d90e1fb54db0f10b4b9397efe55f5b09e7ac5513e506a2a3d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f122e633432c4e2e198781a4ff7819f3ff6afcc5987febe8da2392168c26ed8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "007879d42e4cc6d44d40d8b7da701405db2fe054a35fb2693b894dcf8788910a"
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
