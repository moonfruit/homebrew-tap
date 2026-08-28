class Codegraph < Formula
  desc "Local-first code intelligence for AI agents via MCP"
  homepage "https://github.com/colbymchenry/codegraph"
  url "https://registry.npmjs.org/@colbymchenry/codegraph/-/codegraph-1.6.0.tgz"
  sha256 "832d2f608d2366ab48411a8123f91889c4a44407b8b87f3595276e29fd4e0129"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any,                 arm64_tahoe:  "797b4bc094fd079c416ca09ed477fb41adc11d3323c8f4ce961e8c9cfaab61b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "1025ab27c13798ee3bb31d45001c6582684d5eb0e2272fd63fdca85154ff16a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3ccbc1ab11b2534d329c0fa8bf7c708a29dc040918ec0ac37c3c949df906ac8e"
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
