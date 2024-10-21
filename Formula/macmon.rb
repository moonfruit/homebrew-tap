class Macmon < Formula
  desc "Sudoless performance monitor for Apple Silicon"
  homepage "https://github.com/vladkens/macmon"
  url "https://github.com/vladkens/macmon/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "7c027b14b07bf8b5932de2264914057a6e57abc58d5af0e17c17ba6e0c74f3ff"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fde7f6673926f9776a4e688fe04332dcabe8db7f164af32c1e62702f9695071d"
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
