class Impl < Formula
  desc "Go method stub generator"
  homepage "https://github.com/josharian/impl"
  url "https://github.com/josharian/impl/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "d97ef0f70d877fe1b83e971d70bacc5c3b179fb42b0dde08f53bedad7957ac73"
  license "MIT"
  head "https://github.com/josharian/impl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "c80644bf1024cbb1aa44dcbe62923e00abe5190f825bc1393cc267e6f5dcadc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6e14b4dec82cafe59410a0dcb505f283d515876ba5b6171d59716633a2671f7c"
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
