class UutilsSelected < Formula
  desc "Cross-platform Rust rewrite of the GNU coreutils (selected)"
  homepage "https://github.com/uutils/coreutils"
  url "https://github.com/uutils/coreutils/archive/refs/tags/0.9.0.tar.gz"
  sha256 "dafe0126ee4ed55c7cd60c6b559f43724a74751deed3c1b078f4f510311acab2"
  license "MIT"
  head "https://github.com/uutils/coreutils.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any, arm64_tahoe:  "72507f6fd065c0e694c1c108b78a67fee210c5f30020c48bab22bdee3b8eb1ab"
    sha256 cellar: :any, arm64_linux:  "5cf5abe7258ae268d44719048972d0379346aea44e9a12d0382b8bcef50710ff"
    sha256 cellar: :any, x86_64_linux: "eb8034d67d3b2c102c769b10eec1de96535a4b1c2b54daf6e2f871df919b7a0c"
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
      SPHINXBUILD=#{Formula["sphinx-doc"].opt_bin}/sphinx-build
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
