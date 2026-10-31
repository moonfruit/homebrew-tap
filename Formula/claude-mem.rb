class ClaudeMem < Formula
  desc "Persistent memory compression system for Claude Code"
  homepage "https://github.com/thedotmack/claude-mem"
  url "https://registry.npmjs.org/claude-mem/-/claude-mem-15.7.0.tgz"
  sha256 "a7a3ee750f6577aeb9c83f990300464ebe4e0f48d9fcd5b593229d9e37652704"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256                               arm64_golden_gate: "f396eafafa0140cd245103b0198366adb9b529da3b4701d2f5516260e9c77f8f"
    sha256                               arm64_tahoe:       "f396eafafa0140cd245103b0198366adb9b529da3b4701d2f5516260e9c77f8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4faa1097a2e447daedb172978f7d128279d708a171bfde32dadd3203e8e08d59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "4faa1097a2e447daedb172978f7d128279d708a171bfde32dadd3203e8e08d59"
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
