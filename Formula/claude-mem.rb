class ClaudeMem < Formula
  desc "Persistent memory compression system for Claude Code"
  homepage "https://github.com/thedotmack/claude-mem"
  url "https://registry.npmjs.org/claude-mem/-/claude-mem-16.0.2.tgz"
  sha256 "808e89f36aea2d62bf9ac34da14c8fe48bd145ba72c9e432e0c591d24dec4776"
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
