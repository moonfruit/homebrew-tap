class Sing2seq < Formula
  desc "Transporter used to send sing-box logs to seq"
  homepage "https://github.com/moonfruit/sing2seq"
  url "https://github.com/moonfruit/sing2seq/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "6d06a71c55c3f417057d586de434202f8f444981683fb2f33002922799c0a3ca"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "4dc2099257925cc124a2a04cc4328ab355a214d2c6c4852e1acd8b0d45c35f05"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b6497602b7315f1a702c99be5f785a41376bb8495c6996c10c58663134b4a4e1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
    generate_completions_from_executable(bin/"sing2seq", shell_parameter_format: :cobra)
  end

  test do
    assert_match "sing2seq version #{version}", shell_output("#{bin}/sing2seq --version")
  end
end
