class Impl < Formula
  desc "Go method stub generator"
  homepage "https://github.com/josharian/impl"
  url "https://github.com/josharian/impl/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "fcc2344f5386583a2cfda9b0830e347eb6e8b946c0b3e3260bbb4b8479eb2c25"
  license "MIT"
  revision 4
  head "https://github.com/josharian/impl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8968cf06a7543f104bbbdca8f01a2c25b2fd711b3cd3264a80083eacdf75b878"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2fcdff68ebc32c424fa294123e6ab5c19d4abae04ee4a2bc570f2fced704e23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25218c1d427d8cf982c2efb42d2a3129a671654c3cfbacf98af2c402a89199a4"
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
