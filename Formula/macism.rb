class Macism < Formula
  desc "Reliable CLI macOS input source manager"
  homepage "https://github.com/laishulu/macism"
  url "https://github.com/laishulu/macism/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "ca8ddeccc8e5ee4e3b497c1aa5c715c63bae2775b44511c0ec5ef9b4438f2863"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "7a71334d50dd589dc1ddb9edc208f66d62591a7a7384764da6e6aac85b37c9ee"
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
