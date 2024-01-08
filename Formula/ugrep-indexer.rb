class UgrepIndexer < Formula
  desc "Monotonic indexer to speed up ugrep"
  homepage "https://github.com/Genivia/ugrep-indexer"
  url "https://github.com/Genivia/ugrep-indexer/archive/refs/tags/v0.9.5-2.tar.gz"
  sha256 "02d303ea482ba38862e6da4257106188da34a488c2390ed0846b6a53352079b1"
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
