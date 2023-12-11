class UgrepIndexer < Formula
  desc "Monotonic indexer to speed up ugrep"
  homepage "https://github.com/Genivia/ugrep-indexer"
  url "https://github.com/Genivia/ugrep-indexer/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "cd6bf98e3094e3dbbabcf2ac4b642e25e811974f5fdc9f5aa9ecaf04e9725d2d"
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
