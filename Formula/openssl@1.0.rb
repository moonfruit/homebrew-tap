class OpensslAT10 < Formula
  desc "SSL/TLS cryptography library"
  homepage "https://openssl.org/"
  url "https://www.openssl.org/source/openssl-1.0.2u.tar.gz"
  sha256 "ecd0c6ffb493dd06707d38b14bb4d8c2288bb7033735606569d8f90f89669d16"

  livecheck do
    url "https://www.openssl.org/source/old/1.0.2/"
    regex(/href=.*?openssl[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    rebuild 2
    sha256 arm64_sonoma: "9aecc6e0d20d55ea734c00b1b6ec4724771d5558f5b0066593206f8e1407a7c2"
    sha256 x86_64_linux: "66affb41455be28d67579aa60f8a2749daae31d01604494694bcfed670070298"
  end

  keg_only :versioned_formula

  depends_on "ca-certificates"

  patch do
    url "https://raw.githubusercontent.com/lavabit/magma/682101e08114be9b006aadb228943c487dfb1abf/lib/patches/openssl/1.0.2_update_expiring_certificates.patch"
    sha256 "095276ed70550d87305de552e686107543d7c7225a32079da22a9ad1c1e895ad"
  end

  patch do
    on_arm do
      url "https://gist.githubusercontent.com/felixbuenemann/5f4dcb30ebb3b86e1302e2ec305bac89/raw/b339a33ff072c9747df21e2558c36634dd62c195/openssl-1.0.2u-darwin-arm64.patch"
      sha256 "4ad22bcfc85171a25f035b6fc47c7140752b9ed7467bb56081c76a0a3ebf1b9f"
    end
  end

  def install
    # OpenSSL will prefer the PERL environment variable if set over $PATH
    # which can cause some odd edge cases & isn't intended. Unset for safety,
    # along with perl modules in PERL5LIB.
    ENV.delete("PERL")
    ENV.delete("PERL5LIB")

    # -O2 or greater with clang > 13 causes elliptic curve miscompilation on arm64
    ENV.O1 if OS.mac? && Hardware::CPU.arm? && (MacOS.version >= :monterey) && (ENV.compiler == :clang)

    ENV.deparallelize

    args = %W[
      --prefix=#{prefix}
      --openssldir=#{openssldir}
      no-ssl2
      no-ssl3
      no-zlib
      shared
      enable-cms
    ]
    if OS.mac?
      args += %W[darwin64-#{Hardware::CPU.arch}-cc enable-ec_nistp_64_gcc_128]
    elsif Hardware::CPU.intel?
      args << (Hardware::CPU.is_64_bit? ? "linux-x86_64" : "linux-elf")
    elsif Hardware::CPU.arm?
      args << (Hardware::CPU.is_64_bit? ? "linux-aarch64" : "linux-armv4")
    end

    openssldir.mkpath
    system "perl", "./Configure", *args
    system "make", "depend"
    system "make"
    system "make", "install", "MANDIR=#{man}", "MANSUFFIX=ssl"
    system "make", "test"
  end

  def openssldir
    etc/"openssl@1.0"
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
    # Make sure the necessary .cnf file exists, otherwise OpenSSL gets moody.
    assert_predicate openssldir/"openssl.cnf", :exist?,
            "OpenSSL requires the .cnf file for some functionality"

    # Check OpenSSL itself functions as expected.
    (testpath/"testfile.txt").write("This is a test file")
    expected_checksum = "e2d0fe1585a63ec6009c8016ff8dda8b17719a637405a4e23c0ff81339148249"
    system "#{bin}/openssl", "dgst", "-sha256", "-out", "checksum.txt", "testfile.txt"
    open("checksum.txt") do |f|
      checksum = f.read(100).split("=").last.strip
      assert_equal checksum, expected_checksum
    end
  end
end
