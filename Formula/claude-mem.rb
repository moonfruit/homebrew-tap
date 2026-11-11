class ClaudeMem < Formula
  desc "Persistent memory compression system for Claude Code"
  homepage "https://github.com/thedotmack/claude-mem"
  url "https://registry.npmjs.org/claude-mem/-/claude-mem-15.16.0.tgz"
  sha256 "c874cf3f52ca454cbc422a38c4c59f3f2f29dd92a1f23a852f0b247408702628"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256               arm64_golden_gate: "42d267e7668056d71056079930dbcb83a24b640046bd490aa257e82bb87f3d60"
    sha256               arm64_tahoe:       "42d267e7668056d71056079930dbcb83a24b640046bd490aa257e82bb87f3d60"
    sha256 cellar: :any, arm64_linux:       "bd14812857b9463d7624c89e09a1e5c980dd4f86acb1b7a7b27d8e9c401963b9"
    sha256 cellar: :any, x86_64_linux:      "cc2e70c151c6254a873314409670d20da598f01684b38ef1c8d54d239c562174"
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
