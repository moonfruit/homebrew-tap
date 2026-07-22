class Codegraph < Formula
  desc "Local-first code intelligence for AI agents via MCP"
  homepage "https://github.com/colbymchenry/codegraph"
  url "https://registry.npmjs.org/@colbymchenry/codegraph/-/codegraph-1.5.0.tgz"
  sha256 "57549a4e130b4281a70fb7b4a263e99d1c258a54d3c10044625f40af632eb167"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "621046125d9e2c787abe14ffc624bd6542cdf8273bcf25e7e55a2581ecef0767"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "46a5d2d84310ed32005702bf2955d1043c823b36cdcb6892f434521d5b2776ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "269fba5626862401c280fd5673aa6f0796ca022cc8d770eaabb295e01bafb86d"
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
