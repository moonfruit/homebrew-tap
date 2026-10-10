class ClaudeMem < Formula
  desc "Persistent memory compression system for Claude Code"
  homepage "https://github.com/thedotmack/claude-mem"
  url "https://registry.npmjs.org/claude-mem/-/claude-mem-13.35.0.tgz"
  sha256 "a5d7b646541e1a839572095a31682b0e121929c1b3c6e80e29b27eb0a702a67a"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256                               arm64_golden_gate: "e27f8bb96edd554c23f3af8500ca7314bb312ddc054945f31a9e24787fe7f98c"
    sha256                               arm64_tahoe:       "e27f8bb96edd554c23f3af8500ca7314bb312ddc054945f31a9e24787fe7f98c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f8d8d076003c080ccb168d7843967f9b55c5918d57bc607fec47bd53fa71d981"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f8d8d076003c080ccb168d7843967f9b55c5918d57bc607fec47bd53fa71d981"
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
