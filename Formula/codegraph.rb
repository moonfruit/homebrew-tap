class Codegraph < Formula
  desc "Local-first code intelligence for AI agents via MCP"
  homepage "https://github.com/colbymchenry/codegraph"
  url "https://registry.npmjs.org/@colbymchenry/codegraph/-/codegraph-1.0.1.tgz"
  sha256 "288cdc247136dd1513bd28046918476d11ac299226966abc01f7765c6168d1a1"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "68ac3cc4fadf9fe3b2597d51cb491b3d241ed1dbc20b3c0e456a837fc31030b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "5de527f241001ceddccf994b2a531b1a7b688c87e71fd4894957d3007c98f6f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "73654d56524c05d92c2fe8554c7ffaa6ace6789e3881709a22e510f6940b9def"
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
