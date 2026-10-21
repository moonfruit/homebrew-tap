class ClaudeMem < Formula
  desc "Persistent memory compression system for Claude Code"
  homepage "https://github.com/thedotmack/claude-mem"
  url "https://registry.npmjs.org/claude-mem/-/claude-mem-15.0.1.tgz"
  sha256 "6946ba10237b5272b63bd87c0795741127f87bd69a549c2f520f255d738f4016"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256                               arm64_golden_gate: "0583c7a246818329f44daa375671bbb17ca7f4184d8f0842f9f8ff75653a18ec"
    sha256                               arm64_tahoe:       "0583c7a246818329f44daa375671bbb17ca7f4184d8f0842f9f8ff75653a18ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a173a98aa603c7c6a4eb7bc3725bca9dabf7e44838127b8f56c24306c5b5166c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a173a98aa603c7c6a4eb7bc3725bca9dabf7e44838127b8f56c24306c5b5166c"
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
