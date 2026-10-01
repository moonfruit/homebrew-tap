class Tscurl < Formula
  desc "CURL that support TLCP"
  homepage "https://github.com/Tongsuo-Project/curl"
  url "https://github.com/Tongsuo-Project/curl/archive/refs/tags/v2025.3.9-SM.tar.gz"
  sha256 "5948965f5b9c2975fe5ced0d152fcf1cce66ecf138afde6cfe24a8b615013240"
  license "curl"
  revision 3
  head "https://github.com/Tongsuo-Project/curl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:-SM)?$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any, arm64_golden_gate: "97c8c1ab31c4a46e1325d4209f2a8542e1b4feb928b31b3eb2eb473f1fe53389"
    sha256 cellar: :any, arm64_tahoe:       "2cb72b89ef1b978e74be368778024534e7b2b6a5886c630910f3c09ca63c9a01"
    sha256 cellar: :any, arm64_linux:       "6de7ee332cf1c4f4cc4baa3cdb08bc66e909f08a51055710199b13e0ca68f72a"
    sha256 cellar: :any, x86_64_linux:      "0c08cb58ec5e3357021594515c5ed3e9a28a4b3c0052fb588e79ec868c6c2b1f"
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
