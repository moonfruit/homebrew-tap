class Tscurl < Formula
  desc "CURL that support TLCP"
  homepage "https://github.com/Tongsuo-Project/curl"
  url "https://github.com/Tongsuo-Project/curl/archive/refs/tags/v2025.3.9-SM.tar.gz"
  sha256 "5948965f5b9c2975fe5ced0d152fcf1cce66ecf138afde6cfe24a8b615013240"
  license "curl"
  head "https://github.com/Tongsuo-Project/curl.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:-SM)?$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any,                 arm64_sequoia: "741f9d7e8da08ca7915bce33f53345b09cb0364df67046e9b0a0d0cc3afba242"
    sha256 cellar: :any,                 ventura:       "68a39aa3bb3d44f375c287c8fd3326031766b69dbf085a43dd835158df5ce448"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7743d246309f9fa7a342a09e402b4fb555f1a90b8ee250f1b224382a8f280d0c"
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
    system "autoreconf", "--force", "--install", "--verbose"

    args = %W[
      --program-prefix=ts
      --disable-silent-rules
      --with-ssl=#{Formula["tongsuo"].opt_prefix}
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
    system bin/"tscurl", "--tlcp", "-fk", "https://ebssec.boc.cn/"
  end
end
