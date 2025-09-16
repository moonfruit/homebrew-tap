class CodebuddyCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://cnb.cool/codebuddy/codebuddy-code"
  url "https://registry.npmjs.org/@tencent-ai/codebuddy-code/-/codebuddy-code-1.0.17.tgz"
  sha256 "5ecf492c97387924ee5deda3b44be7f8c09b7ddf9033111bcbbc791d657937c1"
  license "MIT"
  revision 1

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
