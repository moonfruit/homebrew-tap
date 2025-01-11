class GostAT3 < Formula
  desc "Go simple tunnel"
  homepage "https://gost.run/"
  url "https://github.com/go-gost/gost/archive/refs/tags/v3.0.0-nightly.20250110.tar.gz"
  version "3.0.0-nightly.20250110"
  sha256 "b9c958041d121f3e99f10462a30d74d7ca74a9a0ebf062f39f9fbe788b018050"
  license "MIT"
  head "https://github.com/go-gost/gost.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-nightly\.\d+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa14a597811eff6bd2ac7ecaa795560ed6ea69bfa01ff0dd7c502e86e4323ea9"
    sha256 cellar: :any_skip_relocation, ventura:       "657bebc92dc549fa40f8703146eb8a4295e2280b2a8019cc94072d5dab8abcb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eab34dfe5e40e620332e0d58748795c02d98373fbf485adb6e47cd33f5e6b3d4"
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
