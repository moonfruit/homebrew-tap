class ClaudeMem < Formula
  desc "Persistent memory compression system for Claude Code"
  homepage "https://github.com/thedotmack/claude-mem"
  url "https://registry.npmjs.org/claude-mem/-/claude-mem-15.3.0.tgz"
  sha256 "d10aa91a8cd800fefd6a511bd46ec859502afe1ee224ca294257be3b92a7fd37"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256                               arm64_golden_gate: "65ebbd322c8d3f18be0eb9c5956560cb54153e2b99a1a5fee1b372113e4f213d"
    sha256                               arm64_tahoe:       "65ebbd322c8d3f18be0eb9c5956560cb54153e2b99a1a5fee1b372113e4f213d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "07624f0ea93e07b47aa6a12ea717196cc0516c14946bf024d96e942694fd2844"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "07624f0ea93e07b47aa6a12ea717196cc0516c14946bf024d96e942694fd2844"
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
