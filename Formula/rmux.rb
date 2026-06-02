class Rmux < Formula
  desc "Terminal multiplexer with a tmux-style CLI and typed Rust SDK"
  homepage "https://rmux.io"
  url "https://github.com/Helvesec/rmux/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "6ff9ab1b4f393a880bc594ed87c85837b1ea0071b3f94ad18855f9d150f99c28"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Helvesec/rmux.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "rmux.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rmux -V")
  end
end
