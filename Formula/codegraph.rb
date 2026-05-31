class Codegraph < Formula
  desc "Local-first code intelligence for AI agents via MCP"
  homepage "https://github.com/colbymchenry/codegraph"
  url "https://registry.npmjs.org/@colbymchenry/codegraph/-/codegraph-0.9.7.tgz"
  sha256 "d18e26127253211beee8fe97e93bacee58ea9b296263d4932409032703c9133d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "60b23222a5565aa56d0fdc2c195e9d214f19dfd86bc927f81e07d698512d3fde"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "e1be9aad271deba45988016e06282cddc8b7d82fb65a7a058289d032500e7a8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c83a24238c13253f8308878e1c5daf0def6c8f395ce8f28a61da78e5438d2b2d"
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
