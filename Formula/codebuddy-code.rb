class CodebuddyCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://cnb.cool/codebuddy/codebuddy-code"
  url "https://registry.npmjs.org/@tencent-ai/codebuddy-code/-/codebuddy-code-2.97.0.tgz"
  sha256 "a3d62e11fd6b6acc9a3261142ba6041e3bc703935c4ae74258ea89d7ee1cbc51"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any,                 arm64_tahoe:  "c9d7e0bca1931e7f438b4fb29394e48490dcc4c4ae0bf13c1f1f2a1798649f5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "fe7ee40df0261208d6b692e87e8e9ae9d9887a14c3efb788707a5b7bb1058a7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6048509b879b8e4db10f9cbfaffa4412171a5c0179afe874c907c60460adeb72"
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
