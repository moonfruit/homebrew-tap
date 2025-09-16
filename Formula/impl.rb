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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "32b330cb70d78564d7a904f12e943090ef0e67ff8fa7e3e40685b7839b0928d8"
    sha256 cellar: :any_skip_relocation, ventura:      "ac8cc0019fe587792213efaa04fffeab44be1971943a16377b73e84d7df8bb0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5e5277d632c051c6a65e9c50e394af67eaf8d9f08e762f1a419648488f7ec1d3"
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
