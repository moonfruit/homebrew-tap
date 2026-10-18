class ClaudeMem < Formula
  desc "Persistent memory compression system for Claude Code"
  homepage "https://github.com/thedotmack/claude-mem"
  url "https://registry.npmjs.org/claude-mem/-/claude-mem-14.0.1.tgz"
  sha256 "48fb5123bc0f9d7f5962692775b9b6293be8bba2566006d8a608cb42bf301bd8"
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
