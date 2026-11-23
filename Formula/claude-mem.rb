class ClaudeMem < Formula
  desc "Persistent memory compression system for Claude Code"
  homepage "https://github.com/thedotmack/claude-mem"
  url "https://registry.npmjs.org/claude-mem/-/claude-mem-16.0.3.tgz"
  sha256 "cd75a61896cd1ee963932ed479a1cc8741310045f67c993bb118b8b9e728013c"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    manifest_sha256 "2e71abf45e9d58f6654309f2111de8783db21788454a99ffc1565e63588564dd"
    sha256               arm64_golden_gate: "f6c110a9a6aa080f8975b3d3f0170cace4557184df6b5497eb68b0e0b19f41d9"
    sha256               arm64_tahoe:       "f6c110a9a6aa080f8975b3d3f0170cace4557184df6b5497eb68b0e0b19f41d9"
    sha256 cellar: :any, arm64_linux:       "d5555d3c76bc889baeb89881e3c2af33c95f392e93ac96707b04280497673838"
    sha256 cellar: :any, x86_64_linux:      "3eef6aaebf773c41c714145ae4a870327c0a23c153679fe694206eb8b46fc975"
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
