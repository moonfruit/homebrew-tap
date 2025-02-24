class LzcCli < Formula
  desc "Client for Lazycat hardware"
  homepage "https://www.npmjs.com/package/@lazycatcloud/lzc-cli"
  url "https://registry.npmjs.org/@lazycatcloud/lzc-cli/-/lzc-cli-1.2.63.tgz"
  sha256 "1ff63716d79b529805b8e7985da37a7a45882a08b7fcde72489d435dfa2df17a"
  license "ISC"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args

    rm(Dir[libexec/"**/dprint-node.{linux,win32}-*.node"])
    rm(Dir[libexec/"**/dprint-node.darwin-x64.node"]) if Hardware::CPU.arm?
    rm(Dir[libexec/"**/dprint-node.darwin-arm64.node"]) if Hardware::CPU.intel?

    bin.install_symlink Dir["#{libexec}/bin/*"]

    generate_completions_from_executable(bin/"lzc-cli", "completion", shells: [:bash, :zsh])
  end

  test do
    assert_match "lzc-cli #{version}", shell_output("#{bin}/lzc-cli --version")
  end
end
