class Codegraph < Formula
  desc "Local-first code intelligence for AI agents via MCP"
  homepage "https://github.com/colbymchenry/codegraph"
  url "https://registry.npmjs.org/@colbymchenry/codegraph/-/codegraph-1.1.6.tgz"
  sha256 "690333a48af483e8d65dc901101c45aac149825bdc6a648346ca2c566bc51864"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "683d82f27dffeba88c847f2f68f03c73e1f28dd6f4143110f23431df94f0138d"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "ab2ad534481a5e532f42ec27903c6244c65388fcec52ee123ff24a768521feed"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "08a7fc14b25cc3e75de72eac67c5fc30326caacf72e1d9e8db9b8a2915d9ae31"
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
