class Codegraph < Formula
  desc "Local-first code intelligence for AI agents via MCP"
  homepage "https://github.com/colbymchenry/codegraph"
  url "https://registry.npmjs.org/@colbymchenry/codegraph/-/codegraph-1.6.0.tgz"
  sha256 "832d2f608d2366ab48411a8123f91889c4a44407b8b87f3595276e29fd4e0129"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    rebuild 2
    sha256 cellar: :any,                 arm64_golden_gate: "3340923cc991fbcdab4d26c0695d80abe905a046f308ca449337212be339e94b"
    sha256 cellar: :any,                 arm64_tahoe:       "3340923cc991fbcdab4d26c0695d80abe905a046f308ca449337212be339e94b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "62d9d3211a7d7fbc460594ba39b30c1117f55fe1551cafff000512c906da2495"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "7c3c2774e25065ac35d2935cbc3c19a91eec13ae268458fe0a17fcdc8442a34d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codegraph --version")
  end
end
