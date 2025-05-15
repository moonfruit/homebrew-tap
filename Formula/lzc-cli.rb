class LzcCli < Formula
  desc "Client for Lazycat hardware"
  homepage "https://www.npmjs.com/package/@lazycatcloud/lzc-cli"
  url "https://registry.npmjs.org/@lazycatcloud/lzc-cli/-/lzc-cli-1.3.3.tgz"
  sha256 "2528065eed9ffd02d1c5d21e79c12cee57048ef293fda844fdfbd30d375a2e9c"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any,                 arm64_sequoia: "519aaa3f80fec8e892d011977ede1e811c29a1dffd3cc9b29247cbe27447f2be"
    sha256 cellar: :any,                 ventura:       "b2581ab11951ed8d8d052c80cc675ea1e5d948fe298125664545ce827d9b9cd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "695c6ebcfc8988d90e86ea462d13518508b2cee87e2e950fc95a1ff190a8f9af"
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
