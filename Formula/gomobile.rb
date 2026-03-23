class Gomobile < Formula
  desc "Manager for geo resources"
  homepage "https://github.com/MetaCubeX/geo"
  url "https://github.com/SagerNet/gomobile/archive/refs/tags/v0.1.12.tar.gz"
  sha256 "53d49268c542accb1d4a4784008b61f0fc13d32610a783ba320555f4e8cafa8c"
  license "BSD-3-Clause"
  head "https://github.com/SagerNet/gomobile.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "f4f60cd567ae53ee9b7f21f96a3fa69a32b8c754bbc0214201a29365ad3f0bf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "cb7f2d6f5d39f804719036eee23f5546316eb7bad6eab448ee42acae81ec7fd5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gomobile"
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"gobind"), "./cmd/gobind"
  end

  test do
    system bin/"gomobile", "help"
  end
end
