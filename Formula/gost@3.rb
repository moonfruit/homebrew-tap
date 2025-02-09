class GostAT3 < Formula
  desc "Go simple tunnel"
  homepage "https://gost.run/"
  url "https://github.com/go-gost/gost/archive/refs/tags/v3.0.0-nightly.20250208.tar.gz"
  version "3.0.0-nightly.20250208"
  sha256 "dd3c8f51a144131c3fa683d06dbadb413ed38cc072acbc06324ef6753b6544be"
  license "MIT"
  head "https://github.com/go-gost/gost.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-nightly\.\d+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "297d6c85a0ede0660bca0735a1c784a4d3e2af074efd04dca8c1d27ff3ef8e1c"
    sha256 cellar: :any_skip_relocation, ventura:       "857091e981eb477e5904352e9cdddec5a665dde9d1fc98f4067f3d19ba0f3c8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fee79b32d6258d35aa505659f8b93d3e4f2d581ba3822bedb569dfb13d3d5c31"
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
