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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c47b46a614317e4daeb35ed8a4d26e6263395a4bac17e8d7ad5401ed8557ba9d"
    sha256 cellar: :any_skip_relocation, ventura:       "4f78b95f5da3e7c409c6e4611f6ab88f1ac9fe59562c2cc78eda2006ed8f9ccb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8f714bdb67e971aa892d03cab3c2a17453531bb63a7b1877331dabd9a2ad513"
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
