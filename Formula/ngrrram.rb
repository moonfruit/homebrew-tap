class Ngrrram < Formula
  desc "TUI tool to help you type faster and learn new layouts"
  homepage "https://github.com/wintermute-cell/ngrrram/"
  url "https://github.com/wintermute-cell/ngrrram/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "6979fe829e773489cc22e45e37784565f2b8e514047e48e64909fa5ff93696af"
  license "GPL-3.0-or-later"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/ngrrram", "--help"
  end
end
