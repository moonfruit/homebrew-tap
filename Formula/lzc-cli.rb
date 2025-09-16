class LzcCli < Formula
  desc "Client for Lazycat hardware"
  homepage "https://www.npmjs.com/package/@lazycatcloud/lzc-cli"
  url "https://registry.npmjs.org/@lazycatcloud/lzc-cli/-/lzc-cli-1.3.10.tgz"
  sha256 "720bf8b05e9d8f2407855816f66b5f1b4790f6455a45fbd1b33b0bf64f38b100"
  license "ISC"
  revision 2

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any,                 arm64_tahoe:   "718f44eff8c30fb239fbd8c38109cca253300072daea04215108f13c358c4126"
    sha256 cellar: :any,                 arm64_sequoia: "0886b4054410aa99eb880f0ca2bb41f7fd2ed28bbf3c6b925eef64c29bd03970"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f4fce817b3bb1baa59e7a651ca05ec41322f5d93cb3df8c9a56a58f712448ba"
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
