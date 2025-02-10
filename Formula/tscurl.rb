class Tscurl < Formula
  desc "CURL that support TLCP"
  homepage "https://github.com/Tongsuo-Project/curl"
  url "https://github.com/Tongsuo-Project/curl/archive/refs/tags/v2023.10.31-SM.tar.gz"
  sha256 "4251c0200d8c97947c7163a1b5cfe5ed38d7b8f4b7680f73c62b9d42a0568059"
  license "curl"
  head "https://github.com/Tongsuo-Project/curl.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:-SM)?$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    rebuild 2
    sha256 cellar: :any,                 ventura:      "fa785208a1be021d0e8b89fd7be32e7d29c124eca0ef3034c29a55fdf5510310"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6482d8428c48e132e16206830e83331bf6c8b5a32edac93cb8bc458f4f10dc32"
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
