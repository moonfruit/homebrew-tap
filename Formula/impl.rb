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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13dd70dac89fdca7625ea64bfa22a292a41fc5b82e1685123306f1f38220b491"
    sha256 cellar: :any_skip_relocation, ventura:       "88356a73896546e8a5e6f91b7eea6caad9954d73ca6f50ff4c19399bb7a6e0fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "746bab4360ba336829bd38cfeaa1a34ca70deac5499f7b8365a2e3ca17b5acda"
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
