class ClaudeMem < Formula
  desc "Persistent memory compression system for Claude Code"
  homepage "https://github.com/thedotmack/claude-mem"
  url "https://registry.npmjs.org/claude-mem/-/claude-mem-16.1.3.tgz"
  sha256 "68ece315714cde7cf6d062df1ea88c35bd19f6ebffb4115550c547db2a04b29e"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    manifest_sha256 "8b2485bcec5c4c8377172b8f0f32245d441d435c83c1f53c2c04f28bc190a2ba"
    sha256               arm64_golden_gate: "cb1f5c9d33610d2d3801c2bb8ee69c13420f0521819158bb95192db80c33c9b7"
    sha256               arm64_tahoe:       "cb1f5c9d33610d2d3801c2bb8ee69c13420f0521819158bb95192db80c33c9b7"
    sha256 cellar: :any, arm64_linux:       "0f4895da3292603db674721e9f25a3a34f74fe199a607a68bf59ac7fc8c3b9b8"
    sha256 cellar: :any, x86_64_linux:      "12456aad4a938722987b78425c57f15f923db3ae2b87b9a41cf512a67e83ab49"
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
