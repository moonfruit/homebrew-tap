class ClaudeMem < Formula
  desc "Persistent memory compression system for Claude Code"
  homepage "https://github.com/thedotmack/claude-mem"
  url "https://registry.npmjs.org/claude-mem/-/claude-mem-13.37.0.tgz"
  sha256 "2860340c889b142d20d7c770dd68157d9a665e24595b2918e8c7c11eeaa805c0"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256                               arm64_golden_gate: "852c404ba2e10f0a01d9b89232e446f4e45f0658e7fb31eb17b867a86a7b0bae"
    sha256                               arm64_tahoe:       "852c404ba2e10f0a01d9b89232e446f4e45f0658e7fb31eb17b867a86a7b0bae"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b80614e27198337fd8cf2423bfef472529b7f5a185b51a2cead48f4a76b92f31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b80614e27198337fd8cf2423bfef472529b7f5a185b51a2cead48f4a76b92f31"
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
