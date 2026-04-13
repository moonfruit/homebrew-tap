class Sing2seq < Formula
  desc "Transporter used to send sing-box logs to seq"
  homepage "https://github.com/moonfruit/sing2seq"
  url "https://github.com/moonfruit/sing2seq/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "7064dd1d4d15c19a629fefe586cfeab2f6cca9b431722d5c0fec609cf6674daf"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "c980114781d4f460f1d5ea8a4a51ab1f4921e76775975ed2719d6cf8a6892ce2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "dec7262590eeb58c3034ec9d4f7929cce7944d894838810aef9b1586798d26c5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
    bin.install "sing-box-wrap.sh"
  end

  test do
    assert_match "sing2seq #{version}", shell_output("#{bin}/sing2seq -version")
  end
end
