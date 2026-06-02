class Rmux < Formula
  desc "Terminal multiplexer with a tmux-style CLI and typed Rust SDK"
  homepage "https://rmux.io"
  url "https://github.com/Helvesec/rmux/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "6ff9ab1b4f393a880bc594ed87c85837b1ea0071b3f94ad18855f9d150f99c28"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Helvesec/rmux.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "38fd2ae47d24aa18b84b5d466e041c1e026118bdb64b9d56d9a9aeb7bdb36b8d"
    sha256 cellar: :any,                 arm64_linux:  "cf33cb3c200026a8bd60610c99062858f3e0aa0799a4b235f3d1b323698b8aee"
    sha256 cellar: :any,                 x86_64_linux: "878206b0726e70f48c177cf97884070c1b473207bcf1659a63ead302036eb072"
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
