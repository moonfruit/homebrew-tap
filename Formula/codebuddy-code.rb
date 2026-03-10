class CodebuddyCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://cnb.cool/codebuddy/codebuddy-code"
  url "https://registry.npmjs.org/@tencent-ai/codebuddy-code/-/codebuddy-code-2.56.1.tgz"
  sha256 "472619eb70a2422053a33467dd30fa9062b1015564f88c821f3de8ae0a517d3d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any,                 arm64_tahoe:  "b1c28235534b3fe525610f533d99ba6c60574daf637ea37fb0528f7c432bdf12"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f27897ce0785017d0719f4aacf7fe2d49b549c604c004f8ea997735b21f95f37"
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
