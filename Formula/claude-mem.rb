class ClaudeMem < Formula
  desc "Persistent memory compression system for Claude Code"
  homepage "https://github.com/thedotmack/claude-mem"
  url "https://registry.npmjs.org/claude-mem/-/claude-mem-15.1.0.tgz"
  sha256 "c87a805f6d5698625ba0df43a733065b95cb857a2862da0e13917c2bf6903a3b"
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
