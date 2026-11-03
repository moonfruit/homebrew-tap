class ClaudeMem < Formula
  desc "Persistent memory compression system for Claude Code"
  homepage "https://github.com/thedotmack/claude-mem"
  url "https://registry.npmjs.org/claude-mem/-/claude-mem-15.9.0.tgz"
  sha256 "9d4a2fd7e19077452a803d6e6b0e3f07d6983a241b96758b6d43648806bff531"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256               arm64_golden_gate: "67af668cb1d7d1d8201b9e1b1100d47907054b11ccde68395ce84ae8f512d7fd"
    sha256               arm64_tahoe:       "67af668cb1d7d1d8201b9e1b1100d47907054b11ccde68395ce84ae8f512d7fd"
    sha256 cellar: :any, arm64_linux:       "cf2ab1cf70342792a50af8db2a73692868b71db5ba235dc640f09059132c3838"
    sha256 cellar: :any, x86_64_linux:      "2d32b488610be7f9d47356d83d2803811743f3fe499ea55b094ec7d61635c852"
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
