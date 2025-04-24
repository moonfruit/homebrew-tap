class LzcCli < Formula
  desc "Client for Lazycat hardware"
  homepage "https://www.npmjs.com/package/@lazycatcloud/lzc-cli"
  url "https://registry.npmjs.org/@lazycatcloud/lzc-cli/-/lzc-cli-1.3.2.tgz"
  sha256 "ea70a9d65f940bc15121bca9f1c2bed0e6ceb8ebdb3e86e162abc4f2606e8ef1"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any,                 arm64_sequoia: "7e3a35b0cb0694e796f7345294d0865b8d791bcf90c9685c56ba3b5134e395b8"
    sha256 cellar: :any,                 ventura:       "f0a52e4e1b1fbe21d24b5e3d5d225c3705e594e1c17c45a23ec31c1c1c3caecb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e50ac139d06d362dd0b7b04419ee88713e5e0099d53d5458c3fd1615a1b98c08"
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
