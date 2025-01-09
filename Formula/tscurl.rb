class Tscurl < Formula
  desc "CURL that support TLCP"
  homepage "https://github.com/Tongsuo-Project/curl"
  url "https://github.com/Tongsuo-Project/curl/archive/refs/tags/v2023.10.31-SM.tar.gz"
  sha256 "4251c0200d8c97947c7163a1b5cfe5ed38d7b8f4b7680f73c62b9d42a0568059"
  license "curl"
  head "https://github.com/Tongsuo-Project/curl.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)(?:-SM)?$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma: "80d3d9fe19815a530dd2a26ead3c206fbc998ed82a3d26e3b48d03ae0d54aafe"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c7312c03ea8282ce9eabfdcd5d11262fb7cfbbf7e1bae45cb20a767a31185878"
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

  uses_from_macos "zlib"

  def install
    system "git", "apply", "tongsuo.patch"
    system "autoreconf", "-fi"

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --disable-ldap
      --prefix=#{prefix}
      --program-prefix=ts
      --with-ca-fallback
      --with-openssl=#{Formula["tongsuo"].opt_prefix}
      --without-ca-bundle
      --without-ca-path
      --without-default-ssl-backend
      --without-librtmp
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"tscurl", "--tlcp", "-fk", "https://ebssec.boc.cn/"
  end
end
