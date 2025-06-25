class Impl < Formula
  desc "Go method stub generator"
  homepage "https://github.com/josharian/impl"
  url "https://github.com/josharian/impl/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "fcc2344f5386583a2cfda9b0830e347eb6e8b946c0b3e3260bbb4b8479eb2c25"
  license "MIT"
  revision 2
  head "https://github.com/josharian/impl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e608be25ce964eb6f991f4c9b20ca170cddf964dd5d2d2232bb951201b49eab"
    sha256 cellar: :any_skip_relocation, ventura:       "365a5549f694bb54adfa268202af96a1957900e1165ae72e041f3cfc2ae36115"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc105b090e13ecef64633daf225c1ff69bc29557503f2875b07b5bb660680905"
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
