class Macism < Formula
  desc "Reliable CLI macOS input source manager"
  homepage "https://github.com/laishulu/macism"
  url "https://github.com/laishulu/macism/archive/refs/tags/v3.0.10.tar.gz"
  sha256 "e333c5f158452494e159a9b8d848b14c72876ae891cdf83981f57f4fcf045e1f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "525ab0198ee0c2bd42bb72809112a964912c14d8658fd4ce65ff4baf0b3db019"
    sha256 cellar: :any_skip_relocation, sequoia:     "adb06c9247842604b0d297f5576c49bcd7f7edc8191bf252c69ef7c3d5409f6d"
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
