class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.0.7.tgz"
  sha256 "0c469ae2e122b822013c08e21c23a03f1bedb0d5e5fbcdb0323027ca9b1ffb4d"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "554ed4612712f733fdb4e90d3f3dedfcd457ede6b676e04c736cc598cd383b9a"
    sha256 cellar: :any_skip_relocation, ventura:       "a193e9e1b76984ec86cf81acb86461bede0656f32d4d61c6b8f46ab7ee7dd09c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef4a51becb5a4cb160d2054c60ed471d7623db94390ef525aa7a6897fa35ff8e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qwen --version")
  end
end
