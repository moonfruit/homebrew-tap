class Impl < Formula
  desc "Go method stub generator"
  homepage "https://github.com/josharian/impl"
  url "https://github.com/josharian/impl/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "838b01f1b3529998baa40736895f38b52e2a778308b31bd0876a5f68b45f9a6e"
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
