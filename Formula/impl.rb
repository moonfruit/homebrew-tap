class Impl < Formula
  desc "Go method stub generator"
  homepage "https://github.com/josharian/impl"
  url "https://github.com/josharian/impl/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "1a5e02e396c4d60811780af4de44ba25ff96d851d240f8b39c2086def5ecfd6d"
  license "MIT"
  head "https://github.com/josharian/impl.git"

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: libexec/"impl")
    (bin/"impl").write_env_script libexec/"impl", GOROOT: "${GOROOT:-#{Formula["go"].opt_libexec}}"
  end

  test do
    system "#{bin}/impl", "Test", "io.Reader"
  end
end
