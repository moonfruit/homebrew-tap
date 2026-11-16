class ClaudeMem < Formula
  desc "Persistent memory compression system for Claude Code"
  homepage "https://github.com/thedotmack/claude-mem"
  url "https://registry.npmjs.org/claude-mem/-/claude-mem-15.18.5.tgz"
  sha256 "4960658a18b6a4cfeb20da3240ed7e65805ec487c735fad35fc49eab9cac63cd"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256               arm64_golden_gate: "15823bce2e947ec7645cfb2b22f886d6970092227a71fd4232110ec1e5a020b5"
    sha256               arm64_tahoe:       "15823bce2e947ec7645cfb2b22f886d6970092227a71fd4232110ec1e5a020b5"
    sha256 cellar: :any, arm64_linux:       "dd9a0046d150a52d4f2006efc3ae9eafa34d7197465fbf11fe59a1d2f6b2cebb"
    sha256 cellar: :any, x86_64_linux:      "4ebed1a29a47c5114b4641043101126f362bc29933dd42b26b8e6d48523bd181"
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
