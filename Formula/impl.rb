class Impl < Formula
  desc "Go method stub generator"
  homepage "https://github.com/josharian/impl"
  url "https://github.com/josharian/impl/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "d97ef0f70d877fe1b83e971d70bacc5c3b179fb42b0dde08f53bedad7957ac73"
  license "MIT"
  head "https://github.com/josharian/impl.git", branch: "main"

  bottle do
    rebuild 1
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
