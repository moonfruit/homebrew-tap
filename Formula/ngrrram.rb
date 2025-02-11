class Ngrrram < Formula
  desc "TUI tool to help you type faster and learn new layouts"
  homepage "https://github.com/wintermute-cell/ngrrram/"
  url "https://github.com/wintermute-cell/ngrrram/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "6979fe829e773489cc22e45e37784565f2b8e514047e48e64909fa5ff93696af"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "556780c319249acc4f987ac68d3786afe35e63f5736bf02ac4e5de2c6430f365"
    sha256 cellar: :any_skip_relocation, ventura:       "e214ec0dbb59bbab4d4907947f1d22e94200f6269bc48f876220d5f5bac54055"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09f2a531d79d67345956348c7f4367df57f92e696e47d65eb0646f731ff71fb0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"ngrrram", "--help"
  end
end
