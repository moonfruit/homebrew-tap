class Macmon < Formula
  desc "Sudoless performance monitor for Apple Silicon"
  homepage "https://github.com/vladkens/macmon"
  url "https://github.com/vladkens/macmon/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "16ea6952ed9ff63aad0bf5288577bbbae7cc5d04e2f755d4a16fe5708030991d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a6f703d22eb3aa2d448f5933b7df13e78a4e2c0614abda0d6aef31994ca5bbc"
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
