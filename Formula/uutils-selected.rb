class UutilsSelected < Formula
  desc "Cross-platform Rust rewrite of the GNU coreutils (selected)"
  homepage "https://github.com/uutils/coreutils"
  url "https://github.com/uutils/coreutils/archive/refs/tags/0.13.0.tar.gz"
  sha256 "5830c023555ea8e98505e8cfb09524d3097f427c5e58ef197a943e6cb73af9b0"
  license "MIT"
  head "https://github.com/uutils/coreutils.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any, arm64_golden_gate: "b68fd3a8629c66ad8774ad28f971a8e45f193a16ec7b79778b7ced81c391d05b"
    sha256 cellar: :any, arm64_tahoe:       "8fdf20af05728d1b421dfc374a8c23233427675fc686ab76437e08e86ceb5934"
    sha256 cellar: :any, arm64_linux:       "0ad77824b70c084e3851afa9f755d0c01bda8e17036ddfa3640b652f4ca47843"
    sha256 cellar: :any, x86_64_linux:      "b5cfe35ac8d686647f98eb321ae2cfae9a9b96bea135b9e465a4e76f3dd7b52a"
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
