class ClaudeMem < Formula
  desc "Persistent memory compression system for Claude Code"
  homepage "https://github.com/thedotmack/claude-mem"
  url "https://registry.npmjs.org/claude-mem/-/claude-mem-15.15.0.tgz"
  sha256 "9522ea08f265665c922da57011ac7035ca8212d52ab6650fb4165b76dc1b3473"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256               arm64_golden_gate: "ad3c848a4265cd3e3d89fffc28c0ac900ed0007c4734969d956c0f2b974dacba"
    sha256               arm64_tahoe:       "ad3c848a4265cd3e3d89fffc28c0ac900ed0007c4734969d956c0f2b974dacba"
    sha256 cellar: :any, arm64_linux:       "3b48e51cb80549e7c23d2cd232ee601ceaa68617adbd453e5161baf512decf44"
    sha256 cellar: :any, x86_64_linux:      "672bd202090a635e672713c8a0c9452530bbaf77cd76767a07c6f95964915056"
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
