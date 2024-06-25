class Impl < Formula
  desc "Go method stub generator"
  homepage "https://github.com/josharian/impl"
  url "https://github.com/josharian/impl/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "fcc2344f5386583a2cfda9b0830e347eb6e8b946c0b3e3260bbb4b8479eb2c25"
  license "MIT"
  head "https://github.com/josharian/impl.git", branch: "main"

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: libexec/"impl")
    (bin/"impl").write_env_script libexec/"impl", GOROOT: "${GOROOT:-#{Formula["go"].opt_libexec}}"
  end

  test do
    system "#{bin}/impl", "Test", "io.Reader"
  end
end
