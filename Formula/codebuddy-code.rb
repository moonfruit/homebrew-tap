class CodebuddyCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://cnb.cool/codebuddy/codebuddy-code"
  url "https://registry.npmjs.org/@tencent-ai/codebuddy-code/-/codebuddy-code-1.1.5.tgz"
  sha256 "6a13fc6047190021fc2dc30f9b18afe3b1b0563daa2cd98f0fd212511bc58752"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "870edbacd47f6d3f4185f29e8905804e5f1a7970b5f0edd08d87f0c9470adf08"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1dc600fa15a3c807d3307c851dbe0e3d0f98fa59c174dd829bc8f7a4888b557b"
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
