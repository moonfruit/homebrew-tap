class Sing2seq < Formula
  desc "Transporter used to send sing-box logs to seq"
  homepage "https://github.com/moonfruit/sing2seq"
  url "https://github.com/moonfruit/sing2seq/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "6d06a71c55c3f417057d586de434202f8f444981683fb2f33002922799c0a3ca"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "4e869ea6f9a9ce46c8afe48e1efb31d3c97dbf0496319be68c0ea7aa3d4765f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "07799b7b8cb93236992f316cb38a4297e414cfdb52bb78b1077a12ec1af68369"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match "sing2seq version #{version}", shell_output("#{bin}/sing2seq --version")
  end
end
