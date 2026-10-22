class Macism < Formula
  desc "Reliable CLI macOS input source manager"
  homepage "https://github.com/laishulu/macism"
  url "https://github.com/laishulu/macism/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "08e08cc9bc3a1cbfe8336af8dddf6d1e4761c2707af3fd7b46f66659945d7b66"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e10b6a8bfb92a3babef9066e72dffa894b822dba6886fcf347dd8c771abb074f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "28f234d5fa266ad5fd05e9650cb2d1a0f7496ba9e7b5e5007f8b5a21e0e7ac3b"
  end

  depends_on :macos

  def install
    system "make", "macism"

    bin.install "macism"
  end

  test do
    assert_match(/com\.apple\.keylayout\.(ABC|US)/, shell_output(bin/"macism"))
  end
end
