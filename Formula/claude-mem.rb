class ClaudeMem < Formula
  desc "Persistent memory compression system for Claude Code"
  homepage "https://github.com/thedotmack/claude-mem"
  url "https://registry.npmjs.org/claude-mem/-/claude-mem-15.0.2.tgz"
  sha256 "77a26ea1845732ccd693b9c2b10ee0b7fa089f2cfff1ced8fbc68d570680611e"
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
