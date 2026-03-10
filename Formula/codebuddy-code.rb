class CodebuddyCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://cnb.cool/codebuddy/codebuddy-code"
  url "https://registry.npmjs.org/@tencent-ai/codebuddy-code/-/codebuddy-code-2.56.1.tgz"
  sha256 "472619eb70a2422053a33467dd30fa9062b1015564f88c821f3de8ae0a517d3d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any,                 arm64_tahoe:  "8079e1c973971d0f2865b219c8b3bcdd8f772f3a8f46fac03d282a414c90ccb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8b2403be6ad0caa86e8d9aeb000c89b47650017b23f6e03151c7266ee60e403c"
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
