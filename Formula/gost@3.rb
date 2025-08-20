class GostAT3 < Formula
  desc "Go simple tunnel"
  homepage "https://gost.run/"
  url "https://github.com/go-gost/gost/archive/refs/tags/v3.2.4.tar.gz"
  sha256 "893aedaaf9b701e6847d14e63a0e5609245dae099e3124f3f1095c44595f7b5e"
  license "MIT"
  head "https://github.com/go-gost/gost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c67f3f9862dcfb71ac918f6a76bea13f177ce8d1469e4e42a54c4cbe37eb7b52"
    sha256 cellar: :any_skip_relocation, ventura:       "c2f678a66791385c5954e3ff213592a1dc39ab50fbce7b64fcdf7f31dfa0ff63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a1ccc1e8579fa61f613919a97c652915bd809cfc7c5bf173f4e65772ba9bde9"
  end

  keg_only :versioned_formula

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"gost"), "./cmd/gost"
    prefix.install "README_en.md"
  end

  test do
    bind_address = "127.0.0.1:#{free_port}"
    fork do
      exec "#{bin}/gost -L #{bind_address}"
    end
    sleep 2
    output = shell_output("curl -I -x #{bind_address} https://github.com")
    assert_match %r{HTTP/\d+(?:\.\d+)? 200}, output
    assert_match(/Server: GitHub.com/i, output)
  end
end
