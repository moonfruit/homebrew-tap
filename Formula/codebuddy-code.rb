class CodebuddyCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://cnb.cool/codebuddy/codebuddy-code"
  url "https://registry.npmjs.org/@tencent-ai/codebuddy-code/-/codebuddy-code-1.3.0.tgz"
  sha256 "4595a11e4f8f71ee911c0e45e719cceb33dbb4aa479c8b582df2f0d7a1f77b09"
  license "MIT"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any,                 arm64_tahoe:  "e549cb9ef445823707a2233cf8b22072de7f77c5fa2ff4a986383656bdbfb6f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e7f545d6db36c40e8ef6c19e8e9b173b3ceb18496b683b61854475a03d1ef5a2"
  end

  depends_on "node"
  depends_on "pcre2"

  def install
    system "npm", "install", *std_npm_args
    rm(Dir[libexec/"**/x64-win32/**"])
    if OS.mac?
      rm(Dir[libexec/"**/arm64-linux/**"])
      rm(Dir[libexec/"**/x64-linux/**"])
      if Hardware::CPU.arm?
        rm(Dir[libexec/"**/x64-darwin/**"])
      elsif Hardware::CPU.intel?
        rm(Dir[libexec/"**/arm64-darwin/**"])
      end
    elsif OS.linux?
      rm(Dir[libexec/"**/arm64-darwin/**"])
      rm(Dir[libexec/"**/x64-darwin/**"])
      if Hardware::CPU.arm?
        rm(Dir[libexec/"**/x64-linux/**"])
      elsif Hardware::CPU.intel?
        rm(Dir[libexec/"**/arm64-linux/**"])
      end
    end
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codebuddy --version")
    assert_match "No MCP servers configured.", shell_output("#{bin}/codebuddy mcp list")
  end
end
