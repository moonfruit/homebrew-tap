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
    sha256 cellar: :any,                 arm64_sequoia: "11f06e0c2a1ee2b81014ebffc54c63d5028c834f351e978bd3a07ee73a234751"
    sha256 cellar: :any,                 ventura:       "df4a10f19af764a38c6f7deeed5221258aa4ff9c8e9067587bfb677b2b3ed0ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38ec55b5c745bcb6694dff92ec645e4bd59e8a0b34946d089271e1af16c9a112"
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
