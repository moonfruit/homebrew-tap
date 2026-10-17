class ClaudeMem < Formula
  desc "Persistent memory compression system for Claude Code"
  homepage "https://github.com/thedotmack/claude-mem"
  url "https://registry.npmjs.org/claude-mem/-/claude-mem-13.41.0.tgz"
  sha256 "4028fea31ebefef45475df2bc34d72a49e19bf01d2401be2b3f15515a0941bd1"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256                               arm64_golden_gate: "dcd11fdf3d000dad57205bf881598f8b59f86c175a656daed47708330761aa8a"
    sha256                               arm64_tahoe:       "dcd11fdf3d000dad57205bf881598f8b59f86c175a656daed47708330761aa8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8020430a1a90c5689897cd4c7f77baf156423a1dae17fcb0d0954627b059a8df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "8020430a1a90c5689897cd4c7f77baf156423a1dae17fcb0d0954627b059a8df"
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
