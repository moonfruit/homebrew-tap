class ClaudeMem < Formula
  desc "Persistent memory compression system for Claude Code"
  homepage "https://github.com/thedotmack/claude-mem"
  url "https://registry.npmjs.org/claude-mem/-/claude-mem-17.0.2.tgz"
  sha256 "66d00edd8ecb11b7c019d37dcf3504f1e701bbb733f1eb8ebd0dadf43a36cebf"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    manifest_sha256 "9e9ac6a7c375b8bb5d82cd320c195cf69a7f498176e5e934506186f5a363d493"
    sha256               arm64_golden_gate: "06102bc01103081bfc29bd5e107fcc1cf1399d93592e5612196a61972f2b4189"
    sha256               arm64_tahoe:       "06102bc01103081bfc29bd5e107fcc1cf1399d93592e5612196a61972f2b4189"
    sha256 cellar: :any, arm64_linux:       "a968169618878b8321b4078739d7071ec868be8b60e3cfe0fbbbdc090af3f2d5"
    sha256 cellar: :any, x86_64_linux:      "998640242ccfb5a4fbd9b595a25097cb18f044ff2060854712c069fe1189ce67"
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
