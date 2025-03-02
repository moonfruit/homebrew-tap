class LzcCli < Formula
  desc "Client for Lazycat hardware"
  homepage "https://www.npmjs.com/package/@lazycatcloud/lzc-cli"
  url "https://registry.npmjs.org/@lazycatcloud/lzc-cli/-/lzc-cli-1.2.63.tgz"
  sha256 "1ff63716d79b529805b8e7985da37a7a45882a08b7fcde72489d435dfa2df17a"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any,                 arm64_sequoia: "b6c16cb7c0b7333106fb76c0df4020b7fed7f77c9ca089b2fd15a6f16819eb0d"
    sha256 cellar: :any,                 ventura:       "565ff2afa73125681de95a140b2eeee75e960a3c489d2ec2502a6685ed55ae2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5ec5c2576a98ddc4dcaeabe064605a048a94d7750a55a1088fff0f546e44ae3"
  end

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
