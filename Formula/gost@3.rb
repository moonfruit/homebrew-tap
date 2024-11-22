class GostAT3 < Formula
  desc "Go simple tunnel"
  homepage "https://gost.run/"
  url "https://github.com/go-gost/gost/archive/refs/tags/v3.0.0-nightly.20241117.tar.gz"
  version "3.0.0-nightly.20241117"
  sha256 "c3e683509c664a799dce4c58cf88b88198f2b5f09d8898ec6e229a219a3365a6"
  license "MIT"
  head "https://github.com/go-gost/gost.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-nightly\.\d+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b91b255aeef839930d65e61ee1c6f7a78b0247d82f04d93409005060e7cc5df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8d5b60646d105f55d0397b0dead234b857f6dfe4f1cf2d95a01f3774c566339"
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
