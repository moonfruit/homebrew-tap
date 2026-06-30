class Codegraph < Formula
  desc "Local-first code intelligence for AI agents via MCP"
  homepage "https://github.com/colbymchenry/codegraph"
  url "https://registry.npmjs.org/@colbymchenry/codegraph/-/codegraph-1.1.4.tgz"
  sha256 "8f0a039f59058fefc56934b7d229d6709ef52eba49442a2df15befac7603c5e8"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "9263fbce29b9c43ec15a3f7a341b2c7c8c545852ee1899edd22c1e2975d9a3a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "2c4af7e913c384d087e01dbc1927498fcaace9971827abda852191eda4bd5910"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "417fc8380a0a89842b31913a39686fad517befd5f8c31517458d55fefeab1c27"
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
