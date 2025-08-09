class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.0.5.tgz"
  sha256 "1b92595e24bd8648eff58b3c5e08d3b082536b9f3cc5a3beee64d0c543a612ef"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bbe6eaa03294f89499b1b6b24eac6fafe9a722ed930041d0ec525024dcf6e361"
    sha256 cellar: :any_skip_relocation, ventura:       "3801e3a69eb944a967fbc92b19650f892d2baa7723fa3289ac303b588f8b26f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9d8560e03729479f01ad52fb83c2cf687a2078212e87346e4901d9efc3fda26"
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
