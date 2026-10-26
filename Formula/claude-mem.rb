class ClaudeMem < Formula
  desc "Persistent memory compression system for Claude Code"
  homepage "https://github.com/thedotmack/claude-mem"
  url "https://registry.npmjs.org/claude-mem/-/claude-mem-15.2.1.tgz"
  sha256 "428980a109d6fa439af80a003854d0ec8ba4812044d0f713ee41c51615917b23"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256                               arm64_golden_gate: "2346264e0cbc9a00959b8cc57afa0404252a0a480956cea538b838652813e05a"
    sha256                               arm64_tahoe:       "2346264e0cbc9a00959b8cc57afa0404252a0a480956cea538b838652813e05a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ecb811c759f4b1b553efd4d9c7770dc53c090268b633dfa0e560679252a133ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ecb811c759f4b1b553efd4d9c7770dc53c090268b633dfa0e560679252a133ec"
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
