class Impl < Formula
  desc "Go method stub generator"
  homepage "https://github.com/josharian/impl"
  url "https://github.com/josharian/impl/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "d97ef0f70d877fe1b83e971d70bacc5c3b179fb42b0dde08f53bedad7957ac73"
  license "MIT"
  head "https://github.com/josharian/impl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2878fe1ed863dd86ea1a7b4b750be03b65e78f4d197bf15da06ddf6ee82079c3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "aed13071a7692dcf8155f1a9a87fa1c63642c39d1a6d069afb58cf6fa533fc5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e566297f5e0996a3565d4461cb14b1cfa3769a2f13981624655ed872e8b0b4d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6e1db749d16d2419d6e9f783c9f0e943a6cd813f3505a3303f731100d256bbbe"
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
