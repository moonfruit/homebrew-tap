class UutilsSelected < Formula
  desc "Cross-platform Rust rewrite of the GNU coreutils (selected)"
  homepage "https://github.com/uutils/coreutils"
  url "https://github.com/uutils/coreutils/archive/refs/tags/0.12.0.tar.gz"
  sha256 "4fb327655cb4ffcbf2f16550cf9234079ffe839692f7aa1a6eda104af684e122"
  license "MIT"
  head "https://github.com/uutils/coreutils.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any, arm64_golden_gate: "c1f6eb41c9db70c308de509dc056bfe1a67d895b43ca0044a35bc396d726384e"
    sha256 cellar: :any, arm64_tahoe:       "939e247bf21085a8ee76a6f638bfcf117694031e9aba7e71c4a47168b96e324b"
    sha256 cellar: :any, arm64_linux:       "68fabdc825d0409d3153204e37ea0af7da971e95ebee95743bcdba6869ef1021"
    sha256 cellar: :any, x86_64_linux:      "d1b983831a9c960c614b6c6715000313dfcd8206fed35a08dfc96caa7bdba024"
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
