class UutilsSelected < Formula
  desc "Cross-platform Rust rewrite of the GNU coreutils (selected)"
  homepage "https://github.com/uutils/coreutils"
  url "https://github.com/uutils/coreutils/archive/refs/tags/0.8.0.tar.gz"
  sha256 "03f765fd23e9cc66f8789edc6928644d8eae5e5a7962d83795739d0a8a85eaef"
  license "MIT"
  head "https://github.com/uutils/coreutils.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any,                 arm64_tahoe:  "5d26890eb325c5c5a6828dee60377df634a5be6202fdad3219d841112a3345fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c053d4368678505478dca445521e6c2c95871724d3166edf9e59419828593e13"
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
