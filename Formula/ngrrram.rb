class Ngrrram < Formula
  desc "TUI tool to help you type faster and learn new layouts"
  homepage "https://github.com/wintermute-cell/ngrrram/"
  url "https://github.com/wintermute-cell/ngrrram/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "6979fe829e773489cc22e45e37784565f2b8e514047e48e64909fa5ff93696af"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "18d1727e5bbc03fe812e3d99fd43edd672617b00212681383cdb05e33f24c334"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "73cdc30e080ab6daf86fec403338cca70cafbccd73d2f4b3c679ac76bc4377dc"
    sha256 cellar: :any,                 arm64_linux:       "256e6ef2b727cb69f1f9f28ee88d9366a954df93a3b84c1011f9b2ea8cb061b6"
    sha256 cellar: :any,                 x86_64_linux:      "40c865020c1f7fa50373906ae2ab885ac06644a3d48737f2082f2618f1c2fff9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"ngrrram", "--help"
  end
end
