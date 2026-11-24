class ClaudeMem < Formula
  desc "Persistent memory compression system for Claude Code"
  homepage "https://github.com/thedotmack/claude-mem"
  url "https://registry.npmjs.org/claude-mem/-/claude-mem-16.1.1.tgz"
  sha256 "ed74921dbf882f295d341833c8797c1da295e5d5aad7eed91ba9c30153238fc7"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    manifest_sha256 "be90d7db44b74a2218514e0244cfd32c262a8ff0fbae754ac0167e69b1b9cb76"
    sha256               arm64_golden_gate: "7de2be33b37d3e79c81ed928adfb3e4b90ef5c41775200cb41eb3aa54d4e787d"
    sha256               arm64_tahoe:       "7de2be33b37d3e79c81ed928adfb3e4b90ef5c41775200cb41eb3aa54d4e787d"
    sha256 cellar: :any, arm64_linux:       "fa8f6434e71423024a89b5a40b47b31609521e79eeeb177567a8061e7a2121ba"
    sha256 cellar: :any, x86_64_linux:      "2052f7ee18180880282d53054609b358816745ed98eaadff416e10f7e33127ef"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude-mem --version")
  end
end
