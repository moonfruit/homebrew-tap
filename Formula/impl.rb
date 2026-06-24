class Impl < Formula
  desc "Go method stub generator"
  homepage "https://github.com/josharian/impl"
  url "https://github.com/josharian/impl/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "d97ef0f70d877fe1b83e971d70bacc5c3b179fb42b0dde08f53bedad7957ac73"
  license "MIT"
  head "https://github.com/josharian/impl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "bdd09c5d53f8e21b691e034c93d15d16e3225602b31c62674e9cc55995df5600"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "5d545902f1955d87484f6c8da67b69955536cc59a758c1df07539e9ca0adfbae"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c63557c8bc6b494d88ffbac39914464321d73f7051025c0a3b3bf8d096f8d6da"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: libexec/"impl")
    (bin/"impl").write_env_script libexec/"impl", GOROOT: "${GOROOT:-#{formula_opt_libexec("go")}}"
  end

  test do
    system bin/"impl", "Test", "io.Reader"
  end
end
