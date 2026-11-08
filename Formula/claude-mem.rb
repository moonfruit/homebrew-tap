class ClaudeMem < Formula
  desc "Persistent memory compression system for Claude Code"
  homepage "https://github.com/thedotmack/claude-mem"
  url "https://registry.npmjs.org/claude-mem/-/claude-mem-15.12.0.tgz"
  sha256 "78ec517c9a4203e063a8ccc1c9cd3c6b3efef40bc14c4074600107b00e8d76af"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256               arm64_golden_gate: "022d213f83baf4c2d30eedae52638fdf3cb4922c3ca49e13209ddd8bc85986e2"
    sha256               arm64_tahoe:       "022d213f83baf4c2d30eedae52638fdf3cb4922c3ca49e13209ddd8bc85986e2"
    sha256 cellar: :any, arm64_linux:       "2af7ee9a0dbcf57246719cf89636f26804fbe9d11e62c9621dc2b2e114b16839"
    sha256 cellar: :any, x86_64_linux:      "29d9e5a0a4863a9b0313bc5c7d4488d9732fa0841dbcf55024447f8d315ba518"
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
