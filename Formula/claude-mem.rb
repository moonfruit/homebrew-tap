class ClaudeMem < Formula
  desc "Persistent memory compression system for Claude Code"
  homepage "https://github.com/thedotmack/claude-mem"
  url "https://registry.npmjs.org/claude-mem/-/claude-mem-15.12.1.tgz"
  sha256 "77c706a33e428aae5cb0eb41ae09191bd2c61e32bea5d53ae573d30227a9416a"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256               arm64_golden_gate: "5dbb30f2f622a51de8f35ccab4b4347a532bde70599a8382bb572f7ae28b4364"
    sha256               arm64_tahoe:       "5dbb30f2f622a51de8f35ccab4b4347a532bde70599a8382bb572f7ae28b4364"
    sha256 cellar: :any, arm64_linux:       "55778dd89243c8daffa746e9dd2913a50f88f9d27a03c15b15316cf7a3dcbe5a"
    sha256 cellar: :any, x86_64_linux:      "e4b22bfd0f97d954e381d492c113c05d59ec72eb771cc7879b79a044a3545f51"
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
