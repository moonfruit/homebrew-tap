class UutilsSelected < Formula
  desc "Cross-platform Rust rewrite of the GNU coreutils (selected)"
  homepage "https://github.com/uutils/coreutils"
  url "https://github.com/uutils/coreutils/archive/refs/tags/0.5.0.tar.gz"
  sha256 "83535e10c3273c31baa2f553dfa0ceb4148914e9c1a9c5b00d19fbda5b2d4d7d"
  license "MIT"
  head "https://github.com/uutils/coreutils.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "24235ae88cd71a1909cf55ab7ba92a7fa5a67df6473dd06745e8dad01c0d7a74"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f9f922b8f617a0215367acd2a8bd32264e575ba48429fbf9286d013c4e3b90ba"
  end

  depends_on "make" => :build
  depends_on "rust" => :build

  on_macos do
    conflicts_with "coreutils", because: "uutils-selected and coreutils install some same binaries"
  end

  conflicts_with "uutils-coreutils", because: "uutils-selected and coreutils install some same binaries"

  def install
    man1.mkpath

    # Call `make` as `gmake` to use Homebrew `make`.
    system "gmake", "install",
           "PREFIX=#{prefix}",
           "PROFILE=release", "MULTICALL=y",
           "UTILS=basenc dircolors factor hashsum nproc numfmt pinky realpath shred shuf tac timeout"
  end

  test do
    (testpath/"test").write("test")
    (testpath/"test.sha1").write("a94a8fe5ccb19ba61c4c0873d391e987982fbbd3 test")
    system bin/"hashsum", "--sha1", "-c", "test.sha1"
  end
end
