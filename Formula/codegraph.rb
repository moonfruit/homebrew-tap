class Codegraph < Formula
  desc "Local-first code intelligence for AI agents via MCP"
  homepage "https://github.com/colbymchenry/codegraph"
  url "https://registry.npmjs.org/@colbymchenry/codegraph/-/codegraph-1.1.2.tgz"
  sha256 "91e49ba77f372d3d0e5ddfd5f421bcd1b2f4455163fe04eb3d071dd22ee2aff2"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "ca45eca1422106c1280f3db62e2543b105f96786d6ef8c078d547912f44f36fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "07aef2f14090131f12aa7d88c9ea0c1b71ac5b0c69e8028ce51a9be606ff7886"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "74904f0a8858da9b28197145efdbf7df8299587c096a9136261b93dd12fd4a9f"
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
