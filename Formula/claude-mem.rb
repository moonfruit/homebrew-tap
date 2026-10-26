class ClaudeMem < Formula
  desc "Persistent memory compression system for Claude Code"
  homepage "https://github.com/thedotmack/claude-mem"
  url "https://registry.npmjs.org/claude-mem/-/claude-mem-15.2.1.tgz"
  sha256 "428980a109d6fa439af80a003854d0ec8ba4812044d0f713ee41c51615917b23"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256                               arm64_golden_gate: "d91b510d13a409199fb6e089c7c6fcdc4318c03a62c9db3dc8075c2896d7a619"
    sha256                               arm64_tahoe:       "d91b510d13a409199fb6e089c7c6fcdc4318c03a62c9db3dc8075c2896d7a619"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d92df3e834e537196b338bdf8eb8c11fc2b91085104dfa3347b9f5dee2cc25bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "d92df3e834e537196b338bdf8eb8c11fc2b91085104dfa3347b9f5dee2cc25bf"
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
