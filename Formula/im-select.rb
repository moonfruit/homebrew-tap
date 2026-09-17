class ImSelect < Formula
  desc "macOS Input methods selector"
  homepage "https://github.com/moonfruit/im-select"
  url "https://github.com/moonfruit/im-select/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "58ec2bf0f411a918ecab44204e069edaa5ed463320a8eca9e53be06e7ab909db"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "721883e9323677dc3f57f05ca4dd9eb6b0c101752a7d6978070c657aa7d7ca08"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "aa1c0c64199c27973630f2a7a792e6414a6ff2c91870fcb9f11b88a32bc1006c"
  end

  depends_on :macos

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match(/com\.apple\.keylayout\.(ABC|US)/, shell_output(bin/"im-select"))
  end
end
