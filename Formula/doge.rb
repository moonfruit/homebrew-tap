class Doge < Formula
  desc "Reviving A command-line DNS client"
  homepage "https://dns.lookup.dog/"
  url "https://github.com/Dj-Codeman/doge/archive/refs/tags/v0.2.7.tar.gz"
  sha256 "7049e2ccd6907f4f4222b8ea84160d65b57aadbbee9498da353a00c576bc647e"
  license "EUPL-1.2"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "62b35f3ce75f465c4a74f45f17745531721f5ea73ba9e201b6f381bb21a66352"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b827848c454b7c0e55dce9f767eb3ff758266b3b9d6996aebf9d3886601f3eaa"
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
