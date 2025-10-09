class ImSelect < Formula
  desc "macOS Input methods selector"
  homepage "https://github.com/moonfruit/im-select"
  url "https://github.com/moonfruit/im-select/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "58ec2bf0f411a918ecab44204e069edaa5ed463320a8eca9e53be06e7ab909db"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "13fbb8d961a1ab72e6d5cad590b481d4cebe227a7e82f6866f9c155bbd1abe7c"
    sha256 cellar: :any_skip_relocation, sequoia:     "3f5b01831d4d843d6518677836db40870437a6152bf6e6e7d50add375866e2d3"
  end

  depends_on :macos

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match(/com\.apple\.keylayout\.(ABC|US)/, shell_output(bin/"im-select"))
  end
end
