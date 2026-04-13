class Sing2seq < Formula
  desc "Transporter used to send sing-box logs to seq"
  homepage "https://github.com/moonfruit/sing2seq"
  url "https://github.com/moonfruit/sing2seq/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "7064dd1d4d15c19a629fefe586cfeab2f6cca9b431722d5c0fec609cf6674daf"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
    bin.install "sing-box-wrap.sh"
  end

  test do
    assert_match "sing2seq #{version}", shell_output("#{bin}/sing2seq -version")
  end
end
