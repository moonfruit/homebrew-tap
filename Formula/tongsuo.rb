class Tongsuo < Formula
  desc "Modern Cryptographic Primitives and Protocols Library"
  homepage "https://www.tongsuo.net/"
  url "https://github.com/Tongsuo-Project/Tongsuo/archive/refs/tags/8.4.0.tar.gz"
  sha256 "57c2741750a699bfbdaa1bbe44a5733e9c8fc65d086c210151cfbc2bbd6fc975"
  license "Apache-2.0"
  revision 2

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 arm64_tahoe:  "5538f7ad961a7e3b336abe7a8f6fe33c8fdcb5b751946fd3223b82246c23e991"
    sha256 ventura:      "70b4c60fa5aced7098d163d775c0ad04bfe92f84b2cf3bcba608aab67d5ce10c"
    sha256 x86_64_linux: "664fd9aed07586671c8c7201f58e4272e64aec8b0f2337f6329e143ccc85f157"
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
