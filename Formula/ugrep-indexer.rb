class UgrepIndexer < Formula
  desc "Monotonic indexer to speed up ugrep"
  homepage "https://github.com/Genivia/ugrep-indexer"
  url "https://github.com/Genivia/ugrep-indexer/archive/refs/tags/v0.9.5.tar.gz"
  sha256 "bea5f9b9ade0abd32e4d643f909ee98349413468c1792dad0b1dfa688cf74227"
  license "BSD-3-Clause"

  depends_on "xz"

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
