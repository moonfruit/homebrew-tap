class Codegraph < Formula
  desc "Local-first code intelligence for AI agents via MCP"
  homepage "https://github.com/colbymchenry/codegraph"
  url "https://registry.npmjs.org/@colbymchenry/codegraph/-/codegraph-0.9.9.tgz"
  sha256 "6ee4d4b24f9fb6add9b89567b8b41e44c05c7563dfe48513f3f41229ab3b2fb4"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "6ee99d8b2e3c23817f73a38818497c0cfc3a570264f8779657062dcd265e64d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "d251a27684fd9442ffa10cd6cb746cbb3d2fb2b702b4da6f60b54202814b5aa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "68f0df94fdf6acc9065aae36dac5c63dadf0057e0573e129dea495ce6d65684e"
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
