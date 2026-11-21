class ClaudeMem < Formula
  desc "Persistent memory compression system for Claude Code"
  homepage "https://github.com/thedotmack/claude-mem"
  url "https://registry.npmjs.org/claude-mem/-/claude-mem-16.0.1.tgz"
  sha256 "3b7509510074e7d8ae3dc50b3e374114220ee92371e3855a9aed23c4f520f2da"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256               arm64_golden_gate: "0e36846b7feb6648a9d49d64b13d7512670468aaaf63a2d4c7324cc3e005321b"
    sha256               arm64_tahoe:       "0e36846b7feb6648a9d49d64b13d7512670468aaaf63a2d4c7324cc3e005321b"
    sha256 cellar: :any, arm64_linux:       "a54325bf384609d0cbc8929a5cfefb84b4c3c6fc347ed385108e88cb0d16b788"
    sha256 cellar: :any, x86_64_linux:      "12998886be064b8be4e72f3a5acc75d995317b1e3deb6cdc356999fc63243149"
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
