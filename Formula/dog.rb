class Dog < Formula
  desc "Tiny command-line DNS client with support for UDP, TCP, DoT, DoH, DoQ and ODoH"
  homepage "https://github.com/natesales/q"
  url "https://github.com/natesales/q/archive/refs/tags/v0.19.12.tar.gz"
  sha256 "1f56ebfb93fd380dee734cca9227149de2491c49db7b2c0f21019fd463081e4c"
  license "GPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "a625f869898c3539ac321baa41c86f9b5de025d9a949a11604341a3efe8a4665"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6280631fd5539d448a48609ad66600e1dfe1fab67f45958b96a6324689dac9ae"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"dog")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dog --version")
    assert_match "ns: ns1.dnsimple.com.", shell_output("#{bin}/dog brew.sh NS --format yaml")
  end
end
