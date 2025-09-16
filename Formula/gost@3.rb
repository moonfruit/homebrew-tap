class GostAT3 < Formula
  desc "Go simple tunnel"
  homepage "https://gost.run/"
  url "https://github.com/go-gost/gost/archive/refs/tags/v3.2.4.tar.gz"
  sha256 "893aedaaf9b701e6847d14e63a0e5609245dae099e3124f3f1095c44595f7b5e"
  license "MIT"
  revision 2
  head "https://github.com/go-gost/gost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "f5a664b0068c92d9713b8b483d517f856a130ab6e74ea25180fccfb07b1ce49d"
    sha256 cellar: :any_skip_relocation, ventura:      "46c6988c7e357739bbae587f5ab18c7407cd506ebe30d19ed6cee757bea055c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1af2c68d6033f001b7f2d1992d159428ac702b9806f492745f10a25dcdf073f0"
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
