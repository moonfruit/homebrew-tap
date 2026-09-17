class UutilsSelected < Formula
  desc "Cross-platform Rust rewrite of the GNU coreutils (selected)"
  homepage "https://github.com/uutils/coreutils"
  url "https://github.com/uutils/coreutils/archive/refs/tags/0.12.0.tar.gz"
  sha256 "4fb327655cb4ffcbf2f16550cf9234079ffe839692f7aa1a6eda104af684e122"
  license "MIT"
  revision 1
  head "https://github.com/uutils/coreutils.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any, arm64_golden_gate: "412417b705730b60e7764a68685640f15f54577a6b33e5a69b3b0c3ee35fbe0a"
    sha256 cellar: :any, arm64_tahoe:       "93286272720e77117f3199b0e9338018965a9e8347f5c757cec0f4e3a3278907"
    sha256 cellar: :any, arm64_linux:       "5a3dda2fb62987a1862fab9f57e280c8d1c09ce45ed68c9260a2e73d76bca213"
    sha256 cellar: :any, x86_64_linux:      "6c624568478fb89f18686e870d754367db598c26f769543c1a2110c03a53470c"
  end

  depends_on "rust" => :build
  depends_on "sphinx-doc" => :build

  on_linux do
    conflicts_with "coreutils", because: "both install the same binaries"
  end

  conflicts_with "b2sum", because: "both install `b2sum` binaries"

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

    args = [
      "PREFIX=#{prefix}",
      "PROFILE=release",
      "MULTICALL=y",
      "SPHINXBUILD=#{formula_opt_bin("sphinx-doc")}/sphinx-build",
      "UTILS=#{utils.join(" ")}",
      "LN=ln -sf",
    ]
    system "make", "install", *args
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
