class Macmon < Formula
  desc "Sudoless performance monitor for Apple Silicon"
  homepage "https://github.com/vladkens/macmon"
  url "https://github.com/vladkens/macmon/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "6dd9a960d82b68d1e0f3833cf021ba4bcd23b2010c0eebbe9b8f79064230d215"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e9ea15754fb52b74c655f6f02b98a694cb596486cdc87cf0256d78f9f071d55"
  end

  depends_on "rust" => :build
  depends_on arch: :arm64
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "macmon #{version}", shell_output("#{bin}/macmon --version")
  end
end
