class Macism < Formula
  desc "Reliable CLI macOS input source manager"
  homepage "https://github.com/laishulu/macism"
  url "https://github.com/laishulu/macism/archive/refs/tags/v3.1.1.tar.gz"
  sha256 "fbc009123076f06ce10fdffb08587af94809e1a964b9cc15c7ee16f6f8e6a179"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a66f373f27728963a8747d5db7d197e73b0164230e46a78b0ddf48b47e1ce6df"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "69481fa9253c17f98de416265157889634799a132a5e6732de6ea4bdc4b3cc7c"
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
