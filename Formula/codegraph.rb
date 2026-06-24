class Codegraph < Formula
  desc "Local-first code intelligence for AI agents via MCP"
  homepage "https://github.com/colbymchenry/codegraph"
  url "https://registry.npmjs.org/@colbymchenry/codegraph/-/codegraph-1.1.0.tgz"
  sha256 "adf6143cf7a707caffbb8961e6cc1f08eb3d1ded667bd5255c02ba6b8f0ad6e5"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "e21d3622eb339c68a27e0b721b041e5b9dc9a27f505880a0c815649178267003"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "7db2f246a71a159e661906b9c8f642c68dd3f9e500c00eab44dec08096de1fc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "44b9ea032171dcb77c66473d570d3a1ca615f5da3b4cb59f993bbd682df98df7"
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
