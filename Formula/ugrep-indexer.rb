class UgrepIndexer < Formula
  desc "Monotonic indexer to speed up ugrep"
  homepage "https://github.com/Genivia/ugrep-indexer"
  url "https://github.com/Genivia/ugrep-indexer/archive/refs/tags/v0.9.6.tar.gz"
  sha256 "f8084a9ea34321b4062b978c2e1f1d9e1ee6430e83728c3f4bc0cbe91216201a"
  license "BSD-3-Clause"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "brotli"
  depends_on "lz4"
  depends_on "xz"
  depends_on "zstd"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/ugrep-indexer"
    assert_path_exists testpath/"._UG#_Store"
  end
end
