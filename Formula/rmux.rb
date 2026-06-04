class Rmux < Formula
  desc "Terminal multiplexer with a tmux-style CLI and typed Rust SDK"
  homepage "https://rmux.io"
  url "https://github.com/Helvesec/rmux/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "89a07c4f42320a36176ead9d798ec5f486f530cdbec877533387518a463b4c40"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Helvesec/rmux.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "fc997a0af3e5b9d2fa70f10e1ad5c31a884e98193149693c8a2af95cff2256fe"
    sha256 cellar: :any,                 arm64_linux:  "f34de625a533ff7d728f52f67e76df472b834b3832b6b6552fe44292487545cc"
    sha256 cellar: :any,                 x86_64_linux: "c3466cdb109a6aa4902cde4d018e7bf9b08b49e3708ea4241a25d3a2aecff279"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "rmux.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rmux -V")
  end
end
