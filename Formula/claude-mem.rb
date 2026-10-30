class ClaudeMem < Formula
  desc "Persistent memory compression system for Claude Code"
  homepage "https://github.com/thedotmack/claude-mem"
  url "https://registry.npmjs.org/claude-mem/-/claude-mem-15.6.0.tgz"
  sha256 "163c299ba83248d40af7c92273e852bb1bc616b6dfc294e22bb98e54db12feb4"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256                               arm64_golden_gate: "3840077357adb381c780a50d73241c0012d59dd8ddf256ff2255da5e72021bf3"
    sha256                               arm64_tahoe:       "3840077357adb381c780a50d73241c0012d59dd8ddf256ff2255da5e72021bf3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ca1e9b6ea0ee460a5f8b278d39a033eccea85abf4aeb6676f207ff0700a47af8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ca1e9b6ea0ee460a5f8b278d39a033eccea85abf4aeb6676f207ff0700a47af8"
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
