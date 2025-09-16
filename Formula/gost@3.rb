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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad6ae4f2a3b7062b8a30d0caad553e134f71456f63b6bc496b855b73c501efe1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afbf9695cdf92dc9bac3389296adf250098026bf47cd4c5de1ad17bcefae622c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d82b58903bf455e7d2c1eeaefd7d0910b245bc8791b2c48e3915ee6851950792"
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
