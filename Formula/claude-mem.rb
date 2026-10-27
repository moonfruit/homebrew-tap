class ClaudeMem < Formula
  desc "Persistent memory compression system for Claude Code"
  homepage "https://github.com/thedotmack/claude-mem"
  url "https://registry.npmjs.org/claude-mem/-/claude-mem-15.3.0.tgz"
  sha256 "d10aa91a8cd800fefd6a511bd46ec859502afe1ee224ca294257be3b92a7fd37"
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
