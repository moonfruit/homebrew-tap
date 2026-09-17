class Tscurl < Formula
  desc "CURL that support TLCP"
  homepage "https://github.com/Tongsuo-Project/curl"
  url "https://github.com/Tongsuo-Project/curl/archive/refs/tags/v2025.3.9-SM.tar.gz"
  sha256 "5948965f5b9c2975fe5ced0d152fcf1cce66ecf138afde6cfe24a8b615013240"
  license "curl"
  revision 2
  head "https://github.com/Tongsuo-Project/curl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:-SM)?$/i)
  end

  bottle do
    rebuild 2
  end

  keg_only "conflicts with curl"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "brotli"
  depends_on "libnghttp2"
  depends_on "tongsuo"
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "git", "apply", "tongsuo.patch"
    system "autoreconf", "--force", "--install", "--verbose"

    args = %W[
      --program-prefix=ts
      --disable-silent-rules
      --with-ssl=#{formula_opt_prefix("tongsuo")}
      --without-ca-bundle
      --without-ca-path
      --with-ca-fallback
      --without-ldap
      --without-libpsl
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"tscurl", "--tlcp", "-fk", "https://tlcp.gmssl.cn/"
  end
end
