class Codegraph < Formula
  desc "Local-first code intelligence for AI agents via MCP"
  homepage "https://github.com/colbymchenry/codegraph"
  url "https://registry.npmjs.org/@colbymchenry/codegraph/-/codegraph-1.1.1.tgz"
  sha256 "fbdd1ebd0a09391ad83a0ae8ca023cb00a24a57b8f312eeaceebe7605ec4e3f1"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "324875eb1006a410be36cd8d42edbc9ca13ab29fbd578dce5fec7ba315c80658"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "858f18f4bbc90b7c948037e50d5ca82efd7e940a5bcddb28c8e333399381bc73"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "741accb2dc9c5b038979341e1f077dc1e9928f2c59188d4c9749460a27eecb8e"
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
