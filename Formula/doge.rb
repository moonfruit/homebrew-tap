class Doge < Formula
  desc "Reviving A command-line DNS client"
  homepage "https://github.com/Dj-Codeman/doge/"
  url "https://github.com/Dj-Codeman/doge/archive/refs/tags/v0.2.9.tar.gz"
  sha256 "21d459f1f88d6a1e001a747b84782f180c01de8f3c39f3a1389c352b2f2edc88"
  license "EUPL-1.2"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4b351e2ed7bbced02c2d800328ae07c8d02bbf9200c220d2f9800a9ddfc28a6"
    sha256 cellar: :any_skip_relocation, ventura:       "c5e90b652c4ca7d7f11fbf02c9ba001e5da8eb9695d2e51aed302b5b19159c57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54ee3f041d09b0df7560f9ed5a680ab8e46eb4f00a1160716f903dbc08d5a835"
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
