class OpensslAT10 < Formula
  desc "SSL/TLS cryptography library"
  homepage "https://openssl.org/"
  url "https://www.openssl.org/source/openssl-1.0.2u.tar.gz"
  sha256 "ecd0c6ffb493dd06707d38b14bb4d8c2288bb7033735606569d8f90f89669d16"
  revision 1

  livecheck do
    url "https://openssl-library.org/source/old/1.0.2/"
    regex(/href=.*?openssl[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 arm64_tahoe:  "aef5881150cd59f63a45b2dc16fd7f6f4927ad628ee891ffd457df1ba1eec0fd"
    sha256 ventura:      "63ba96b68651411f6463f1143b4023803887157451bfe49699f6545d5f9687df"
    sha256 x86_64_linux: "51f00c906ab4ca72a17a0c4095d753a252e0a58feb23b104e9dbeed3a36d8552"
  end

  keg_only :versioned_formula

  depends_on "ca-certificates"

  patch do
    url "https://gist.github.com/moonfruit/585c8973f9b97657de777e0c9eef22b2/raw/ee6744ce1685f691885e91f97cb4396d280a8e7d/openssl-1.0.2u-update-expiring-certificates.patch"
    sha256 "ccef15995b9983abf2bbaff7e12a867f7cd712a8ae341d4435da11df2ee1302b"
  end

  patch do
    on_macos do
      on_arm do
        url "https://gist.githubusercontent.com/felixbuenemann/5f4dcb30ebb3b86e1302e2ec305bac89/raw/b339a33ff072c9747df21e2558c36634dd62c195/openssl-1.0.2u-darwin-arm64.patch"
        sha256 "4ad22bcfc85171a25f035b6fc47c7140752b9ed7467bb56081c76a0a3ebf1b9f"
      end
    end
  end

  def install
    # OpenSSL will prefer the PERL environment variable if set over $PATH
    # which can cause some odd edge cases & isn't intended. Unset for safety,
    # along with perl modules in PERL5LIB.
    ENV.delete("PERL")
    ENV.delete("PERL5LIB")

    # -O2 or greater with clang > 13 causes elliptic curve miscompilation
    ENV.O1 if OS.mac? && MacOS.version >= :monterey && ENV.compiler == :clang

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
    assert_path_exists openssldir/"openssl.cnf", "OpenSSL requires the .cnf file for some functionality"

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
