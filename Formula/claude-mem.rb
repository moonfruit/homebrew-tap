class ClaudeMem < Formula
  desc "Persistent memory compression system for Claude Code"
  homepage "https://github.com/thedotmack/claude-mem"
  url "https://registry.npmjs.org/claude-mem/-/claude-mem-15.18.2.tgz"
  sha256 "5e25d84aa2da68b88bd4ec1eff7cbc47446238c5795f338f4f97484e080c15d8"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256               arm64_golden_gate: "d06c95ed2d60bb7250e2347798a64c24845c426540647bfcd30d3e3555f6019f"
    sha256               arm64_tahoe:       "d06c95ed2d60bb7250e2347798a64c24845c426540647bfcd30d3e3555f6019f"
    sha256 cellar: :any, arm64_linux:       "75398925c6fd2686d47cbae558531c4902a1d7207b99df79d19e0fc0fbdcb2a9"
    sha256 cellar: :any, x86_64_linux:      "488c89f0564a00bb0032fd7769b3faf31957aca29ac84abcf976bc7c5fe2ed3e"
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
