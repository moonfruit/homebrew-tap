class Codegraph < Formula
  desc "Local-first code intelligence for AI agents via MCP"
  homepage "https://github.com/colbymchenry/codegraph"
  url "https://registry.npmjs.org/@colbymchenry/codegraph/-/codegraph-0.9.9.tgz"
  sha256 "6ee4d4b24f9fb6add9b89567b8b41e44c05c7563dfe48513f3f41229ab3b2fb4"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "a417069f52ceaf82e9105c15a5d65cfe768f833d23b0622dc51bb1ead7c8a13a"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "056a7c113fa288e7e919bdb5a7b8e786500fa1574e865027f5ae0e8fc14f4859"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4534ebb865c8ad3aa6fa98d4a6d2351c95370c6ced48dce952148321d5d47357"
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
