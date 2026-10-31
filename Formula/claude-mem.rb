class ClaudeMem < Formula
  desc "Persistent memory compression system for Claude Code"
  homepage "https://github.com/thedotmack/claude-mem"
  url "https://registry.npmjs.org/claude-mem/-/claude-mem-15.7.0.tgz"
  sha256 "a7a3ee750f6577aeb9c83f990300464ebe4e0f48d9fcd5b593229d9e37652704"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256               arm64_golden_gate: "11a1b0db48dcfcec81a5c23878219a73d1c4292a78d1c20829227a85738142d4"
    sha256               arm64_tahoe:       "11a1b0db48dcfcec81a5c23878219a73d1c4292a78d1c20829227a85738142d4"
    sha256 cellar: :any, arm64_linux:       "36d0891ba9d88835b9aadf7b8ec57d6a88877a21872fb4ed1554159a76e9f8ca"
    sha256 cellar: :any, x86_64_linux:      "1709f30e2cc1b5f0294433f6a423caeae59cec0adae6b3b8ab6a6a7851864c95"
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
