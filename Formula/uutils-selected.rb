class UutilsSelected < Formula
  desc "Cross-platform Rust rewrite of the GNU coreutils (selected)"
  homepage "https://github.com/uutils/coreutils"
  url "https://github.com/uutils/coreutils/archive/refs/tags/0.0.26.tar.gz"
  sha256 "2a0e8511f1e6adf7f1003ce4536b8a8bb1b2289364efe55edf96f2fc9e2f00a4"
  license "MIT"
  head "https://github.com/uutils/coreutils.git", branch: "main"

  depends_on "make" => :build
  depends_on "rust" => :build

  on_macos do
    conflicts_with "coreutils", because: "uutils-selected and coreutils install some same binaries"
    conflicts_with "uutils-coreutils", because: "uutils-selected and coreutils install some same binaries"
    conflicts_with "aardvark_shell_utils", because: "both install `realpath` binaries"
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
