class Doge < Formula
  desc "Reviving A command-line DNS client"
  homepage "https://github.com/Dj-Codeman/doge/"
  url "https://github.com/Dj-Codeman/doge/archive/refs/tags/v0.2.9.tar.gz"
  sha256 "21d459f1f88d6a1e001a747b84782f180c01de8f3c39f3a1389c352b2f2edc88"
  license "EUPL-1.2"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "089fc698a4f9100c7c194a248c3ef04f07c320086a471cb3fa5142b80ad60864"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24763cf687deb8fa98a8b0e64bb7f620c64832c47a51cef64ce58fa56179014c"
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
