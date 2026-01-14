class UutilsSelected < Formula
  desc "Cross-platform Rust rewrite of the GNU coreutils (selected)"
  homepage "https://github.com/uutils/coreutils"
  url "https://github.com/uutils/coreutils/archive/refs/tags/0.5.0.tar.gz"
  sha256 "83535e10c3273c31baa2f553dfa0ceb4148914e9c1a9c5b00d19fbda5b2d4d7d"
  license "MIT"
  revision 1
  head "https://github.com/uutils/coreutils.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "9709bf8ac3409efabef4f5ee4f448e32687ad59ad32f19901415c11a8845eda5"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c201b6a008ad683f20070c46d6dcb964388d6f84c6fff22ff98d352971fb25cd"
  end

  keg_only :versioned_formula

  depends_on "make" => :build
  depends_on "rust" => :build
  depends_on "sphinx-doc" => :build

  def install
    man1.mkpath

    inreplace "GNUmakefile", "$(SELINUX_PROGS)", ""

    utils = %w[
      basenc
      dircolors
      factor
      hashsum
      nproc
      numfmt
      pinky
      realpath
      shred
      shuf
      tac
      timeout
    ]

    args = %W[
      PREFIX=#{prefix}
      PROFILE=release-fast
      MULTICALL=y
      SPHINXBUILD=#{Formula["sphinx-doc"].opt_bin}/sphinx-build
      UTILS=#{utils.join(" ")}
    ]

    # Call `make` as `gmake` to use Homebrew `make`.
    system "gmake", "install", *args
  end

  test do
    (testpath/"test").write("test")
    (testpath/"test.sha1").write("a94a8fe5ccb19ba61c4c0873d391e987982fbbd3 test")
    system bin/"hashsum", "--sha1", "-c", "test.sha1"
  end
end
