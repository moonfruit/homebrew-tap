class ClaudeMem < Formula
  desc "Persistent memory compression system for Claude Code"
  homepage "https://github.com/thedotmack/claude-mem"
  url "https://registry.npmjs.org/claude-mem/-/claude-mem-13.34.2.tgz"
  sha256 "013ca65f73e221352cd022667b9c46e5f6a1380650840afea84cca0b4c685b96"
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
