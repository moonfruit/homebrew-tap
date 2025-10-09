class ImSelect < Formula
  desc "macOS Input methods selector"
  homepage "https://github.com/moonfruit/im-select"
  url "https://github.com/moonfruit/im-select/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "58ec2bf0f411a918ecab44204e069edaa5ed463320a8eca9e53be06e7ab909db"
  license "MIT"

  depends_on :macos

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match(/com\.apple\.keylayout\.(ABC|US)/, shell_output(bin/"im-select"))
  end
end
