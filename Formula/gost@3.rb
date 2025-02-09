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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54be4d1f65e182d8ab511f17ca114f3506d49f6a4874333e2a0b9962b36cf30a"
    sha256 cellar: :any_skip_relocation, ventura:       "4d5fb0ac5f7ba9dd77699ec65426b5fb8a107894ed949b45676ac02369c893d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "daf933c21ccff5f1f7904f27aedf55559e212c264f2266ead37df56e95968727"
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
