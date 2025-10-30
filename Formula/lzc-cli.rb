class LzcCli < Formula
  desc "Client for Lazycat hardware"
  homepage "https://www.npmjs.com/package/@lazycatcloud/lzc-cli"
  url "https://registry.npmjs.org/@lazycatcloud/lzc-cli/-/lzc-cli-1.3.12.tgz"
  sha256 "58e269770873b86f2e981f24edf6d19b65a02df77fb5d2eb6fe4b9446662be10"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any,                 arm64_tahoe:  "46332ae6c6f0f7c89525809420e27f8cb117769bd65bd394f481fc881d2b3bbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d1c09ad54e9a95bb51f415d73ffaf95df46fb0dbd1a12f44c93fb5152d3535df"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args

    rm(Dir[libexec/"**/dprint-node.win32-*.node"])
    if OS.mac?
      rm(Dir[libexec/"**/dprint-node.linux-*.node"])
      rm(Dir[libexec/"**/dprint-node.darwin-x64.node"]) if Hardware::CPU.arm?
      rm(Dir[libexec/"**/dprint-node.darwin-arm64.node"]) if Hardware::CPU.intel?
    else
      rm(Dir[libexec/"**/dprint-node.darwin-*.node"])
      rm(Dir[libexec/"**/dprint-node.linux-*-musl.node"])
      rm(Dir[libexec/"**/dprint-node.linux-x64-*.node"]) if Hardware::CPU.arm?
      rm(Dir[libexec/"**/dprint-node.linux-arm64-*.node"]) if Hardware::CPU.intel?
    end

    bin.install_symlink Dir["#{libexec}/bin/*"]

    generate_completions_from_executable(bin/"lzc-cli", "completion", shells: [:bash, :zsh])
  end

  test do
    assert_match "lzc-cli #{version}", shell_output("#{bin}/lzc-cli --version")
  end
end
