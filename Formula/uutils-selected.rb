class UutilsSelected < Formula
  desc "Cross-platform Rust rewrite of the GNU coreutils (selected)"
  homepage "https://github.com/uutils/coreutils"
  url "https://github.com/uutils/coreutils/archive/refs/tags/0.0.28.tar.gz"
  sha256 "b2e8b2531c52e9b09e55a6b41a8875e5770bcea6e5fa7a01d89d7904cf292cb9"
  license "MIT"
  head "https://github.com/uutils/coreutils.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "45680cd99eccce54014eb580cfd37b4b50c1c9a80d56b9a4c05ac035d123ed18"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "99acd41a9429f02f11cf72fbe49d560b864ef9ea87019bc4058645f126cd7f61"
  end

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
