class Ngrrram < Formula
  desc "TUI tool to help you type faster and learn new layouts"
  homepage "https://github.com/wintermute-cell/ngrrram/"
  url "https://github.com/wintermute-cell/ngrrram/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "6979fe829e773489cc22e45e37784565f2b8e514047e48e64909fa5ff93696af"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "e7c7731025825a04c574d9c669349b54b50bdfbefe37d3d9b5f2b260a4d45a18"
    sha256 cellar: :any_skip_relocation, ventura:      "83f582608d9da2f589c5d47de6ca87e03b8922965b45e47d1f2aad52fa9247b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0f55a6ddda42360ed106567e8f4e16a3b307b81363b5bd55027a5bb23d926286"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"ngrrram", "--help"
  end
end
