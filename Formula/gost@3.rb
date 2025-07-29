class GostAT3 < Formula
  desc "Go simple tunnel"
  homepage "https://gost.run/"
  url "https://github.com/go-gost/gost/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "1b19accf4515c2fc6cbe2549bfc32ecc31ae4a5596aaffb6de8c5fefc26d2fbb"
  license "MIT"
  head "https://github.com/go-gost/gost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d60919068bf8ba6cb7394a65b55058f72ffb325ece7b3aa2bdde14d1d20f2ef"
    sha256 cellar: :any_skip_relocation, ventura:       "ae692c8386b5657c088ee16f6165337b870428be5bed87d9e3ee69210195bdd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6c4e49cd8b456e990b5eff4ea38c1baf907f40f7eec0c879dfd6a275e0281db"
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
