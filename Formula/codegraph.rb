class Codegraph < Formula
  desc "Local-first code intelligence for AI agents via MCP"
  homepage "https://github.com/colbymchenry/codegraph"
  url "https://registry.npmjs.org/@colbymchenry/codegraph/-/codegraph-1.6.0.tgz"
  sha256 "832d2f608d2366ab48411a8123f91889c4a44407b8b87f3595276e29fd4e0129"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    rebuild 1
    sha256 cellar: :any,                 arm64_golden_gate: "220a7b404232d967efdcf6fe587e02c10a41bd57524717ada279eec78dbf5f56"
    sha256 cellar: :any,                 arm64_tahoe:       "d41dac72c082927f39864d249b92b996cfba5b6de926d05d1b6c50ac01522f5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1681d8c9579242beaa5a1ac302812c35a1e4064a575ed8fbe2675a8b1e0ecc91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "9f593414955070ca7a78be08462753644a1c6edec100e4481399b17469234a66"
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
