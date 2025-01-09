class Ngrrram < Formula
  desc "TUI tool to help you type faster and learn new layouts"
  homepage "https://github.com/wintermute-cell/ngrrram/"
  url "https://github.com/wintermute-cell/ngrrram/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "6979fe829e773489cc22e45e37784565f2b8e514047e48e64909fa5ff93696af"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "412362be27d054a21a61ff4647bcc82b0eceeaf584e83faf7160bc941423a735"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a89ee5bc7e54eb77e97782ecb9cfa2e3daed162985a4d2fe1c67cb2b72743fa6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"ngrrram", "--help"
  end
end
