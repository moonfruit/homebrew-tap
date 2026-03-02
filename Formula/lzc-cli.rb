class LzcCli < Formula
  desc "Client for Lazycat hardware"
  homepage "https://www.npmjs.com/package/@lazycatcloud/lzc-cli"
  url "https://registry.npmjs.org/@lazycatcloud/lzc-cli/-/lzc-cli-1.3.16.tgz"
  sha256 "935be7f3586ff53f98727747f5c872807e58eeee43de7cfdfe422d3bbb7252f3"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any,                 arm64_tahoe:  "2fb4ba61056023978f50cba3b995f0fd015c8a9b8796ba96eeafd275feeb1144"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6088c5c9d2f00d381680627b7df6dfa786e97c926b8bdb8e84c3c098fb79d776"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args

    rm(Dir[libexec/"**/dprint-node.win32-*.node"])

    rm(Dir[libexec/"**/prebuilds/android-*/*.bare"])
    rm(Dir[libexec/"**/prebuilds/ios-*/*.bare"])

    if OS.mac?
      rm(Dir[libexec/"**/dprint-node.linux-*.node"])
      rm(Dir[libexec/"**/prebuilds/linux-*/*.bare"])

      if Hardware::CPU.arm?
        rm(Dir[libexec/"**/dprint-node.darwin-x64.node"])
        rm(Dir[libexec/"**/prebuilds/darwin-x64/*.bare"])
      end

      if Hardware::CPU.intel?
        rm(Dir[libexec/"**/dprint-node.darwin-arm64.node"])
        rm(Dir[libexec/"**/prebuilds/darwin-arm64/*.bare"])
      end

    else
      rm(Dir[libexec/"**/dprint-node.darwin-*.node"])
      rm(Dir[libexec/"**/dprint-node.linux-*-musl.node"])
      rm(Dir[libexec/"**/prebuilds/darwin-*/*.bare"])

      if Hardware::CPU.arm?
        rm(Dir[libexec/"**/dprint-node.linux-x64-*.node"])
        rm(Dir[libexec/"**/prebuilds/linux-x64/*.bare"])
      end

      if Hardware::CPU.intel?
        rm(Dir[libexec/"**/dprint-node.linux-arm64-*.node"])
        rm(Dir[libexec/"**/prebuilds/linux-arm64/*.bare"])
      end
    end

    bin.install_symlink Dir["#{libexec}/bin/*"]

    generate_completions_from_executable(bin/"lzc-cli", "completion", shells: [:bash, :zsh])
  end

  test do
    assert_match "lzc-cli #{version}", shell_output("#{bin}/lzc-cli --version")
  end
end
