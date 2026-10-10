class ClaudeMem < Formula
  desc "Persistent memory compression system for Claude Code"
  homepage "https://github.com/thedotmack/claude-mem"
  url "https://registry.npmjs.org/claude-mem/-/claude-mem-13.35.0.tgz"
  sha256 "a5d7b646541e1a839572095a31682b0e121929c1b3c6e80e29b27eb0a702a67a"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256                               arm64_golden_gate: "a53395ccfd87b3b734114c9709f19a8bbfbe4cbf077b8554117ede316f183118"
    sha256                               arm64_tahoe:       "a53395ccfd87b3b734114c9709f19a8bbfbe4cbf077b8554117ede316f183118"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "30cefc90ea336a3bd235c788ae0ffbf66bd17673dfa07ff8d39d2c32559f0034"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "30cefc90ea336a3bd235c788ae0ffbf66bd17673dfa07ff8d39d2c32559f0034"
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
