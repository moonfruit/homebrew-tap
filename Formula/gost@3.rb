class GostAT3 < Formula
  desc "Go simple tunnel"
  homepage "https://gost.run/"
  url "https://github.com/go-gost/gost/archive/refs/tags/v3.2.3.tar.gz"
  sha256 "08d924f74e9c0b10d1cc23c75fa385dca52cc445510298db909c9db72b0f15ce"
  license "MIT"
  head "https://github.com/go-gost/gost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c66c20fc986b539ca588434480d7153f7353440837210fbfc158f12ed654d197"
    sha256 cellar: :any_skip_relocation, ventura:       "0c145d2f6463b480032f946fac1452ae31a9e1a5d049596dfb674d5de65eae07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74c21a769c5d7665af6a5dde69c788de70a85d635eed4765e2cd8278ca5bf32a"
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
