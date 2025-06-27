class GostAT3 < Formula
  desc "Go simple tunnel"
  homepage "https://gost.run/"
  url "https://github.com/go-gost/gost/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "5849f7d2db1c54ee0f1a277ae89b1bafd039c10d9d9f87080e039fe44575b08d"
  license "MIT"
  head "https://github.com/go-gost/gost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fba60bb2df6e6af90506d361d307e9ffff4af8e56972f87013563fd5b25b8a2e"
    sha256 cellar: :any_skip_relocation, ventura:       "2ef3b864afa68cbc2cdbfe8cc7e24d01413a199fab704ed62800168fd7e802c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75315495396204dd1aa23485003b77e4ac8d417cad3f29592d0d8f96705c2788"
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
