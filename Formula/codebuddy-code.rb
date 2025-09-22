class CodebuddyCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://cnb.cool/codebuddy/codebuddy-code"
  url "https://registry.npmjs.org/@tencent-ai/codebuddy-code/-/codebuddy-code-1.1.5.tgz"
  sha256 "6a13fc6047190021fc2dc30f9b18afe3b1b0563daa2cd98f0fd212511bc58752"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "d8ebbdadceda409a07f42845ff6c2876980caa353001da0798af277acc474bc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "29833114a3ab5756fe764b46c90bdefae4bbc7b53da2f995591a14d3cfe7bbf3"
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
