class Codegraph < Formula
  desc "Local-first code intelligence for AI agents via MCP"
  homepage "https://github.com/colbymchenry/codegraph"
  url "https://registry.npmjs.org/@colbymchenry/codegraph/-/codegraph-1.4.1.tgz"
  sha256 "8d34d4ef8ef3bc0b5236ca0ba17c3806eee3d9a681699cc76a0eb7552b0da047"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "cc45b80e3421a7ebc3689004fded66f8750e9296cf4267653644b6ca49c12359"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "06b963659a5c4b0cb79e7fac05123fd5f930f77b53dea036062ddd12d0e8d10e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "dc195400314b4723428b7f4f459274c0389fef4b22555be9437ba5f93cd0fdba"
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
