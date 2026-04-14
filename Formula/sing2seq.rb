class Sing2seq < Formula
  desc "Transporter used to send sing-box logs to seq"
  homepage "https://github.com/moonfruit/sing2seq"
  url "https://github.com/moonfruit/sing2seq/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "354c337c383be449d269a41235f3329056476cb840ba0012a1b28b1945c414b9"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "865a5390f39cdfdab7ef5f0c3e8bae4d902b664b9d2c23bbf8ec9e8b026f35c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c7a25d4a329f63e7e8693de7fe89699accad522d8cd644c0c45bc36c02bbd6dc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match "sing2seq version #{version}", shell_output("#{bin}/sing2seq --version")
  end
end
