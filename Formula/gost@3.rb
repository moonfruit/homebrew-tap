class GostAT3 < Formula
  desc "Go simple tunnel"
  homepage "https://gost.run/"
  url "https://github.com/go-gost/gost/archive/refs/tags/v3.0.0-nightly.20250120.tar.gz"
  version "3.0.0-nightly.20250120"
  sha256 "9951628b259a8a7172995490b1c5817db42bcd6eb13a5e96ece1051310476d43"
  license "MIT"
  head "https://github.com/go-gost/gost.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-nightly\.\d+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3ebe0307303ec1ee229ca5e2ecbe0892040ce1aa82255c1094976471b28836e"
    sha256 cellar: :any_skip_relocation, ventura:       "42237af5324ab072078605bac1ff52180c237ef59b52ff3f068e7cbf9baba774"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66827c59eccac749e698c5443a8c8a76206158e3ed8da972cc5cd194fc465f44"
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
