class Impl < Formula
  desc "Go method stub generator"
  homepage "https://github.com/josharian/impl"
  url "https://github.com/josharian/impl/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "fcc2344f5386583a2cfda9b0830e347eb6e8b946c0b3e3260bbb4b8479eb2c25"
  license "MIT"
  head "https://github.com/josharian/impl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "c63b76ded2ce8b2b6efa74fa69960030de6966549bdc25872318c37a57b241bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "36c6714e2457541373ee661e81b949b81cc71beb3f642c4bba2fd8f9512845a2"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: libexec/"impl")
    (bin/"impl").write_env_script libexec/"impl", GOROOT: "${GOROOT:-#{Formula["go"].opt_libexec}}"
  end

  test do
    system bin/"impl", "Test", "io.Reader"
  end
end
