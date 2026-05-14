class CodebuddyCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://cnb.cool/codebuddy/codebuddy-code"
  url "https://registry.npmjs.org/@tencent-ai/codebuddy-code/-/codebuddy-code-2.97.1.tgz"
  sha256 "b5517d42e874501a1d5a5b49442d2d24d74a4f8fb16109a0aacd55f0766a424d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any,                 arm64_tahoe:  "a867e6644eb56ff0ff60e1fa2eb9d8218a9984f90fb7cd3d5d8724a5749ecadb"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "eef5f84714bf36448fb84e8683d00a0d1c7772b1578a7d4f9da5012aa9509299"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "745a86763c753d12a09301e16522695e059a5bfa65be769b0b2848b2b3c9fcb9"
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
