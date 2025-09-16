class Doge < Formula
  desc "Reviving A command-line DNS client"
  homepage "https://github.com/Dj-Codeman/doge/"
  url "https://github.com/Dj-Codeman/doge/archive/refs/tags/v0.2.9.tar.gz"
  sha256 "21d459f1f88d6a1e001a747b84782f180c01de8f3c39f3a1389c352b2f2edc88"
  license "EUPL-1.2"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e5685487aa73dce46822ccdeca4e57eb23205fb761f710a74f2cb9f1990eae5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50da4a267ebeab4cf7c3255a1704de563d041221a13980c56f328afdac6d72c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56a007f15784a6ba76773e62bf59d83d863db4d4fca9f89fdeafe120fc0f7444"
  end

  depends_on "pandoc" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/doge.bash" => "doge"
    zsh_completion.install "completions/doge.zsh" => "_doge"
    fish_completion.install "completions/doge.fish"

    args = %w[
      --standalone
      --from=markdown
      --to=man
    ]
    system "pandoc", *args, "man/doge.1.md", "-o", "doge.1"
    man1.install "doge.1"
  end

  test do
    output = shell_output("#{bin}/doge dns.google A --seconds --color=never")
    assert_match(/^A\s+dns\.google\.\s+\d+\s+8\.8\.4\.4/, output)
    assert_match(/^A\s+dns\.google\.\s+\d+\s+8\.8\.8\.8/, output)
  end
end
