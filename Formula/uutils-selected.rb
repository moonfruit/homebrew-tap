class UutilsSelected < Formula
  desc "Cross-platform Rust rewrite of the GNU coreutils (selected)"
  homepage "https://github.com/uutils/coreutils"
  url "https://github.com/uutils/coreutils/archive/refs/tags/0.11.0.tar.gz"
  sha256 "a47966117783bef18650cc724f1b1d061b717ac91a0feaabdd34910703cf70a4"
  license "MIT"
  head "https://github.com/uutils/coreutils.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any, arm64_tahoe:  "5399106a5cc3e4df30e751ecbf6f30688cff13ce885507eef00af92ac1166abc"
    sha256 cellar: :any, arm64_linux:  "5559cffa4959fff0d6d276fd2abfc42ebb16164f009f23ae0dc5a6da88874bc8"
    sha256 cellar: :any, x86_64_linux: "ba4d9147018b4393bbd9ece8781ef05c944237920f99dedd3c6bcd5dabf50106"
  end

  keg_only :versioned_formula

  depends_on "make" => :build
  depends_on "rust" => :build
  depends_on "sphinx-doc" => :build

  def install
    man1.mkpath

    utils = %w[
      basenc
      dircolors
      factor
      b2sum
      nproc
      numfmt
      pinky
      realpath
      shred
      shuf
      stdbuf
      tac
      timeout
    ]

    args = %W[
      PREFIX=#{prefix}
      PROFILE=release
      MULTICALL=y
      SPHINXBUILD=#{formula_opt_bin("sphinx-doc")}/sphinx-build
      UTILS=#{utils.join(" ")}
    ]

    # Call `make` as `gmake` to use Homebrew `make`.
    system "gmake", "install", *args
  end

  test do
    (testpath/"test").write("test")
    (testpath/"test.b2").write(
      "a71079d42853dea26e453004338670a53814b78137ffbed07603a41d76a483aa" \
      "9bc33b582f77d30a65e6f29a896c0411f38312e1d66e0bf16386c86a89bea572 test",
    )
    system bin/"b2sum", "-c", "test.b2"
  end
end
