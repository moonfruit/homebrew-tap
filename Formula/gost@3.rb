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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25f37bc444c5f598bb2fac885d9274e5e8bbd7b67a9490b605674aa72d451fbe"
    sha256 cellar: :any_skip_relocation, ventura:       "d08f597fd9018b62385c1bab1496d4732dfdcd9549a98868223b38d873559065"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d416d0f631c5ec38d0991a120f9433a0298e36cc2db5de95b481dd110ac63768"
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
