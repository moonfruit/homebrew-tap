class CodebuddyCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://cnb.cool/codebuddy/codebuddy-code"
  url "https://registry.npmjs.org/@tencent-ai/codebuddy-code/-/codebuddy-code-1.0.12.tgz"
  sha256 "84dee4e745fae53c70a49ce4b81bbada9a145824bd33d088c06884934edf7fed"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdfa2b13fe58b1289a17642c02a0a73b6c564ef5cf1d4e09a892ba2f61c00c3b"
    sha256 cellar: :any_skip_relocation, ventura:       "9c191083df47ebd0f1cb9dbfd55989bddb988ef4c991d0f278352f276edfb381"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0eb19b872161cfbc4b4509001446230d78a0cc078032a6c8e77365414a9a1a92"
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
