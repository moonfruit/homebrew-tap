class UutilsSelected < Formula
  desc "Cross-platform Rust rewrite of the GNU coreutils (selected)"
  homepage "https://github.com/uutils/coreutils"
  url "https://github.com/uutils/coreutils/archive/refs/tags/0.2.2.tar.gz"
  sha256 "4a847a3aaf241d11f07fdc04ef36d73c722759675858665bc17e94f56c4fbfb3"
  license "MIT"
  revision 1
  head "https://github.com/uutils/coreutils.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any,                 arm64_tahoe:  "688b6b23284dd652b4fae2369da773d44da58d24af3ba7f8f432333ce44452fb"
    sha256 cellar: :any,                 ventura:      "38b45d69c315f97a80e66e038890f6f8d0110e2751e3adcb4b4d12c19299927c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6c7dc467912a1c2ee0f95e7683491ec3c06d9d63cd4586d43ad6ab61aeb271d5"
  end

  depends_on "make" => :build
  depends_on "rust" => :build

  on_macos do
    conflicts_with "coreutils", because: "uutils-selected and coreutils install some same binaries"
    conflicts_with "uutils-coreutils", because: "uutils-selected and coreutils install some same binaries"
    conflicts_with "md5sha1sum", because: "both install `md5sum` and `sha1sum` binaries"
  end

  def install
    man1.mkpath

    # Call `make` as `gmake` to use Homebrew `make`.
    system "gmake", "install",
           "PREFIX=#{prefix}",
           "PROFILE=release", "MULTICALL=y",
           "UTILS=basenc dircolors factor hashsum hostid numfmt pinky realpath shred shuf tac"

    bin.install_symlink "coreutils" => "md5sum"
    bin.install_symlink "coreutils" => "sha1sum"
  end

  test do
    (testpath/"test").write("test")
    (testpath/"test.sha1").write("a94a8fe5ccb19ba61c4c0873d391e987982fbbd3 test")
    system bin/"hashsum", "--sha1", "-c", "test.sha1"
  end
end
