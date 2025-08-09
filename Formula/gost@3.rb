class GostAT3 < Formula
  desc "Go simple tunnel"
  homepage "https://gost.run/"
  url "https://github.com/go-gost/gost/archive/refs/tags/v3.2.2.tar.gz"
  sha256 "1b127ed18131a6851c5d1a8a72dfa07fd3ab2452eeec22baa62f60c2ed221cb5"
  license "MIT"
  head "https://github.com/go-gost/gost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5f3a1abc28d465c1cb13925150bbcc7e6d81da3285da19d7916ac895984e5af"
    sha256 cellar: :any_skip_relocation, ventura:       "ffb7ae16f6180eef8aae5b137f8798a5d5004b3db07467865510d34d7e3e1bc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1cbca42b8c86df687fd7ecc42901bcff2072c30135c00342c0eb89e84105c1a"
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
