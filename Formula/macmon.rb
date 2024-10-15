class Macmon < Formula
  desc "Sudoless performance monitor for Apple Silicon"
  homepage "https://github.com/vladkens/macmon"
  url "https://github.com/vladkens/macmon/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "4c1ae56cda1566a902843db72c5a3dd9612abb4500aa9d2ad022c4c2bf0b07cd"
  license "MIT"

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
