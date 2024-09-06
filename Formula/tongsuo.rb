class Tongsuo < Formula
  desc "Modern Cryptographic Primitives and Protocols Library"
  homepage "https://www.tongsuo.net"
  url "https://github.com/Tongsuo-Project/Tongsuo/archive/refs/tags/8.4.0.tar.gz"
  sha256 "57c2741750a699bfbdaa1bbe44a5733e9c8fc65d086c210151cfbc2bbd6fc975"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    rebuild 1
    sha256 arm64_sonoma: "32746f7c5b072ddc3d2b3e94c05cd53b2cfbf401011d4693faad97f8238107e8"
    sha256 x86_64_linux: "fdef6a83b2ed94388b176a1a7ac34703edef0a766b00adee0c8e5e4ea3826eb8"
  end

  keg_only "conflicts with openssl"

  depends_on "ca-certificates"

  def install
    openssldir.mkpath
    system "./config", "--prefix=#{prefix}", "--openssldir=#{openssldir}", "--libdir=lib", "--release", "enable-ntls"
    system "perl", "configdata.pm", "--dump"
    system "make"
    system "make", "install"
    system "make", "test"
  end

  def openssldir
    etc/"tongsuo"
  end

  def post_install
    rm(openssldir/"cert.pem") if (openssldir/"cert.pem").exist?
    openssldir.install_symlink Formula["ca-certificates"].pkgetc/"cert.pem"
  end

  def caveats
    <<~EOS
      A CA file has been bootstrapped using certificates from the system
      keychain. To add additional certificates, place .pem files in
        #{openssldir}/certs

      and run
        #{opt_bin}/c_rehash
    EOS
  end

  test do
    (testpath/"testfile.txt").write("This is a test file")
    expected_checksum = "ba7cc1a5be11d5f00dc8a88a9fedd74ccc9faf4655da08b7be3ae7e3954c76f1"
    system bin/"tongsuo", "dgst", "-sm3", "-out", "checksum.txt", "testfile.txt"
    open("checksum.txt") do |f|
      checksum = f.read(100).split("=").last.strip
      assert_equal checksum, expected_checksum
    end
  end
end
