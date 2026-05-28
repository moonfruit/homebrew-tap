class Codegraph < Formula
  desc "Local-first code intelligence for AI agents via MCP"
  homepage "https://github.com/colbymchenry/codegraph"
  url "https://registry.npmjs.org/@colbymchenry/codegraph/-/codegraph-0.9.6.tgz"
  sha256 "c23076656d490724e24020c160686cfb6e85a4ae0267562a80b657a66cacfb35"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "26dd38d20896cdccd12de737fef2852e655149e9ac126165225a13a97abdeff9"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "cf921e683f701a4c614a084500c826c23baf54967b5d65d990f301581c15ab8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "960b351626acc4b726d1508baea60800240e2fbef9c621f3190a06349097ef25"
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
