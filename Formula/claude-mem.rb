class ClaudeMem < Formula
  desc "Persistent memory compression system for Claude Code"
  homepage "https://github.com/thedotmack/claude-mem"
  url "https://registry.npmjs.org/claude-mem/-/claude-mem-15.11.0.tgz"
  sha256 "4d2b9468e5ceaa45223ea81d7b75dd3dba10f160e745e8a214847672eb568da9"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256               arm64_golden_gate: "bc24ea593cea0dd6bfc079524fbc910d560c8ec5f236a1d1785984eec714fd75"
    sha256               arm64_tahoe:       "bc24ea593cea0dd6bfc079524fbc910d560c8ec5f236a1d1785984eec714fd75"
    sha256 cellar: :any, arm64_linux:       "8022733ea670fb5c75914295bdf05c7907a38b28396343894ca5d545e5cd5158"
    sha256 cellar: :any, x86_64_linux:      "84742a0529782d93fbb96940eda26de93c372a5db4e8f7a0a834edec53e76123"
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
