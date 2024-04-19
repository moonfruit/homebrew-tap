class UgrepIndexer < Formula
  desc "Monotonic indexer to speed up ugrep"
  homepage "https://github.com/Genivia/ugrep-indexer"
  url "https://github.com/Genivia/ugrep-indexer/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "e607bbb2c5c2e92284c19f36398926f4a6ba69ab7c24fc2906c099f06b0f001d"
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
