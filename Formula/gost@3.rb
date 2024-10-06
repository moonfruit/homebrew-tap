class GostAT3 < Formula
  desc "Go simple tunnel"
  homepage "https://gost.run/"
  url "https://github.com/go-gost/gost/archive/refs/tags/v3.0.0-nightly.20241002.tar.gz"
  version "3.0.0-nightly.20241002"
  sha256 "6e01b34ac574554d8fc159adfbeadb84f4b8bbc58f1973d126165d6e1e298026"
  license "MIT"
  head "https://github.com/go-gost/gost.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-nightly\.\d+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "1b2446eb87f06bd504ae405d0f53740aae8413807405ccd74a799384309eb42e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "638457d9a9d739c70335bd3e14323eca076ce420f6ab2be3301a25a398fe634d"
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
