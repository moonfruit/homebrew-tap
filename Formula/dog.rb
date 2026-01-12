class Dog < Formula
  desc "Tiny command-line DNS client with support for UDP, TCP, DoT, DoH, DoQ and ODoH"
  homepage "https://github.com/natesales/q"
  url "https://github.com/natesales/q/archive/refs/tags/v0.19.11.tar.gz"
  sha256 "c13dbb556f2eaa26c7bd66632a3ced4026f26486f6563104e919e3cc6d7776ce"
  license "GPL-3.0-only"

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
