class LzcCli < Formula
  desc "Client for Lazycat hardware"
  homepage "https://www.npmjs.com/package/@lazycatcloud/lzc-cli"
  url "https://registry.npmjs.org/@lazycatcloud/lzc-cli/-/lzc-cli-1.3.10.tgz"
  sha256 "720bf8b05e9d8f2407855816f66b5f1b4790f6455a45fbd1b33b0bf64f38b100"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any,                 arm64_sequoia: "cc7ce36be6f78f777b2cac5bb85c9e17f3f300b5f050d3fb0db4c1f9818c3dcd"
    sha256 cellar: :any,                 ventura:       "a1bce9cb7527ac08c3fbe531bdb2a5bea7a76684f606ebd5a5b73b96741ec13e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abd0ba88a9ba5a1cf0b703aeea479c69eadfb7513910838c68974e7124ca677d"
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
