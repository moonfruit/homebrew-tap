class Gomobile < Formula
  desc "Manager for geo resources"
  homepage "https://github.com/MetaCubeX/geo"
  url "https://github.com/SagerNet/gomobile/archive/refs/tags/v0.1.12.tar.gz"
  sha256 "53d49268c542accb1d4a4784008b61f0fc13d32610a783ba320555f4e8cafa8c"
  license "BSD-3-Clause"
  head "https://github.com/SagerNet/gomobile.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gomobile"
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"gobind"), "./cmd/gobind"
  end

  test do
    system bin/"gomobile", "help"
  end
end
