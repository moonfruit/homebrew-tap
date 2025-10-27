class UutilsSelected < Formula
  desc "Cross-platform Rust rewrite of the GNU coreutils (selected)"
  homepage "https://github.com/uutils/coreutils"
  url "https://github.com/uutils/coreutils/archive/refs/tags/0.3.0.tar.gz"
  sha256 "422b4bab88d6a4da9eabcc947b4e8e0c7fbd123c88700f8750da45910bfb03b6"
  license "MIT"
  head "https://github.com/uutils/coreutils.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "22bbaee7358ad35ae3bfbffefdf3b4e1a4571a1f8b3735096f22f571d23152ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "eb947a199ea6d4bc655ed12e038fe0813808112f4af86d751cbcff0d3f1d4861"
  end

  depends_on "make" => :build
  depends_on "rust" => :build

  on_macos do
    conflicts_with "coreutils", because: "uutils-selected and coreutils install some same binaries"
  end

  conflicts_with "uutils-coreutils", because: "uutils-selected and coreutils install some same binaries"
  conflicts_with "md5sha1sum", because: "both install `md5sum` and `sha1sum` binaries"
  conflicts_with "bash-completion@2", because: "both install completions for commands similar to `md5sum`"

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
