class Sing2seq < Formula
  desc "Transporter used to send sing-box logs to seq"
  homepage "https://github.com/moonfruit/sing2seq"
  url "https://github.com/moonfruit/sing2seq/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "9f5ec90f5bd5a4d0434c6053a0e7b44f014b33352bf2ad39a423afd244673049"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "a2c75bb0b87cc1fefa5d9895abdebc9ab6367a6aa0ea9416995cbf0cd9ef5dd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "65c4660055bdb46ab3d9c1f4ec984f6fa488c05b12666115982422dc77672bb9"
  end

  depends_on "go" => :build
  depends_on "bash"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
    bin.install "sing-box-wrap.sh"
  end

  def post_install
    inreplace bin/"sing-box-wrap.sh" do |s|
      s.gsub! "#!/usr/bin/env bash", "#!#{Formula["bash"].opt_bin}/bash"
      s.gsub! ': "${SING2SEQ:=}"', ": \"${SING2SEQ:=#{opt_bin}/sing2seq}\""
    end
  end

  test do
    assert_match "sing2seq #{version}", shell_output("#{bin}/sing2seq -version")
  end
end
