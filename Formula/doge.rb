class Doge < Formula
  desc "Reviving A command-line DNS client"
  homepage "https://dns.lookup.dog/"
  url "https://github.com/Dj-Codeman/doge/archive/refs/tags/v0.2.7.tar.gz"
  sha256 "7049e2ccd6907f4f4222b8ea84160d65b57aadbbee9498da353a00c576bc647e"
  license "EUPL-1.2"

  bottle do
    rebuild 1
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, ventura:      "96d60875ad1f70a102fbff78bbaf9bff0b157ef7f2c7c5aac88cce6be7749ff9"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2e67ed413f0fa8a9a8997475b30c91dee9e9b2099f888f82b2eef9df98f1fee1"
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
