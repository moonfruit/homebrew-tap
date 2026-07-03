class Codegraph < Formula
  desc "Local-first code intelligence for AI agents via MCP"
  homepage "https://github.com/colbymchenry/codegraph"
  url "https://registry.npmjs.org/@colbymchenry/codegraph/-/codegraph-1.2.0.tgz"
  sha256 "db6cd2f7c846da797cc944c1610797aa72d0f33de190a7a54d0d6bf9f3b6bfbc"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "e4e52ed9d5f533014c5e4b7e843176b257ef98ce705d76b7105ad5657f1d6c92"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "94f3a64fa4ad42cfd0b9f36132a35d9a31837e5fa3138ab7995c7ab1b93cacdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0c36bdfada012dbc9c1d86f2ebaf625169c2b74233ee111794b76a6e2203248d"
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
