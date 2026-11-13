class ClaudeMem < Formula
  desc "Persistent memory compression system for Claude Code"
  homepage "https://github.com/thedotmack/claude-mem"
  url "https://registry.npmjs.org/claude-mem/-/claude-mem-15.17.1.tgz"
  sha256 "12c16fc54c825337565a95bb0b21f0f116ab6f75008a98bc31fefdf44b8a991d"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256               arm64_golden_gate: "0ea055c9ecc2ff2c1e5c1b156f00696eda7acfe727d9e522adde6d6847951df0"
    sha256               arm64_tahoe:       "0ea055c9ecc2ff2c1e5c1b156f00696eda7acfe727d9e522adde6d6847951df0"
    sha256 cellar: :any, arm64_linux:       "c4d2a7fdc988b40a285dd4e78122a74e7b3e7118995de5de8fdd42fbbde4dbf7"
    sha256 cellar: :any, x86_64_linux:      "f9af6f6147e3df7fc9ab07d533d6b9d155c852ff8fd300b94713b51ba43c7c91"
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
