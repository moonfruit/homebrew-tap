class Tongsuo < Formula
  desc "Modern Cryptographic Primitives and Protocols Library"
  homepage "https://github.com/Tongsuo-Project/Tongsuo"
  url "https://github.com/Tongsuo-Project/Tongsuo/archive/refs/tags/8.5.0.tar.gz"
  sha256 "505085d457214e5662ea7109c3919fb75f695edf74c91ec6f690da0e58c07dea"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    rebuild 1
    sha256 arm64_golden_gate: "fe1f4e8e0f927083dc85c9346014ac4510d1062cb32e23424cb213ba428dda19"
    sha256 arm64_tahoe:       "512dff41909d4439cb50628b487a45d71c1c6948b79430038be94b63f6cbec13"
    sha256 arm64_linux:       "5a6eb3b237165dc15c12da362af23d89cdcbdec10b6305579d3e5ed842b14dcb"
    sha256 x86_64_linux:      "124dafdbd31b6de3cabd0f9651d5b2aa7708455cb9f17c1c2c0753a935fd51ee"
  end

  keg_only "conflicts with openssl"

  depends_on "ca-certificates"

  # Tests require network access
  allow_network_access! :build

  def install
    openssldir.mkpath
    system "./config", "--prefix=#{prefix}", "--openssldir=#{openssldir}", "--libdir=lib", "--release", "enable-ntls"
    system "perl", "configdata.pm", "--dump"
    system "make"
    system "make", "install"
    # `test_app` runs `openssl` without arguments, which waits on stdin in Tongsuo
    system "make", "HARNESS_JOBS=#{ENV.make_jobs}", "test", "TESTS=-test_app"
  end

  def openssldir
    etc/"tongsuo"
  end

  post_install_steps do
    symlink "{{etc}}/ca-certificates/cert.pem", "{{pkgetc}}/cert.pem", overwrite: true
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
