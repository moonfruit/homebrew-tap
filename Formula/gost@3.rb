class GostAT3 < Formula
  desc "Go simple tunnel"
  homepage "https://gost.run/"
  url "https://github.com/go-gost/gost/archive/refs/tags/v3.0.0-nightly.20240103.tar.gz"
  version "3.0.0-nightly.20240103"
  sha256 "c7b878ddd4b0a9efb3f3c34a8ce01df2885c605237c06584dbb46dc882056b9a"
  license "MIT"
  head "https://github.com/go-gost/gost.git", branch: "master"

  livecheck do
    url :stable
  end

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/new"
    sha256 cellar: :any_skip_relocation, ventura:      "5624d52572ade743032ba3ce8aa95b2c83c0127124ce14bda0dfc95b41787c06"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "284d320aa5c67fc7b866e76070bff68f9592a5446fd957f3b770c9a3e614e6e9"
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
