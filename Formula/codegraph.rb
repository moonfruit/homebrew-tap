class Codegraph < Formula
  desc "Local-first code intelligence for AI agents via MCP"
  homepage "https://github.com/colbymchenry/codegraph"
  url "https://registry.npmjs.org/@colbymchenry/codegraph/-/codegraph-1.2.0.tgz"
  sha256 "db6cd2f7c846da797cc944c1610797aa72d0f33de190a7a54d0d6bf9f3b6bfbc"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "ec5a886aa6d5551235dcb583ee0b95f02a7bb2307d05bdb88bc5928c490077ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "25b77f43c2da1a7a49d197a946f325e6c5f12b0cf987d6fa5a0f297385f9f6ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "15864baf755194a926e0b89115c117acd10757dfb68d519480cc96a0219a5905"
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
