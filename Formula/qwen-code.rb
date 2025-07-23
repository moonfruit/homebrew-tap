class QwenCode < Formula
  desc "Command-line AI workflow tool"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.0.1-alpha.7.tgz"
  sha256 "da5f73a31a3f4138a287945fa037529afa4162a1a390a87eae106211b1ebaa74"
  license "Apache-2.0"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qwen --version")
  end
end
