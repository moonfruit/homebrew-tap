class ClaudeMem < Formula
  desc "Persistent memory compression system for Claude Code"
  homepage "https://github.com/thedotmack/claude-mem"
  url "https://registry.npmjs.org/claude-mem/-/claude-mem-16.1.3.tgz"
  sha256 "68ece315714cde7cf6d062df1ea88c35bd19f6ebffb4115550c547db2a04b29e"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    manifest_sha256 "a5785d398bb6b834f6b4396b79a6c5d6ce5e5ae3d80447dc17cf8f0569803ab8"
    sha256               arm64_golden_gate: "cb725d81894c52bb46efdcd5925b070d190ce63d20af3400a149c677ae7c1d89"
    sha256               arm64_tahoe:       "cb725d81894c52bb46efdcd5925b070d190ce63d20af3400a149c677ae7c1d89"
    sha256 cellar: :any, arm64_linux:       "2bf03467ddf226c5177203fb2ddb56414fae47433815877b77f5cbcdc4d764de"
    sha256 cellar: :any, x86_64_linux:      "263b6136294ddc585ae174be35ace36602ef0d31727abeb98f8b07dd4d3adc27"
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
