class ClaudeMem < Formula
  desc "Persistent memory compression system for Claude Code"
  homepage "https://github.com/thedotmack/claude-mem"
  url "https://registry.npmjs.org/claude-mem/-/claude-mem-15.11.1.tgz"
  sha256 "9dd4c1b160ee5d8b564a83a7c19059b820a89e7473e77d0d99bd26cb9210de4f"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256               arm64_golden_gate: "069136c22a8374d41ff6b8e4f4a0a2e52864a2a1c1c1c6082f4e1d94893aef22"
    sha256               arm64_tahoe:       "069136c22a8374d41ff6b8e4f4a0a2e52864a2a1c1c1c6082f4e1d94893aef22"
    sha256 cellar: :any, arm64_linux:       "dbdc2dedd1a8c35bb198d208186bd7cfa716bcadfedaf47c2cfa2f2d5dcfe51c"
    sha256 cellar: :any, x86_64_linux:      "d33b432cc5639c7f9b136ea195acbb4a2582362a26fe8c21ad931a0d34c7ff51"
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
