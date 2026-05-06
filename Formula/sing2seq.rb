class Sing2seq < Formula
  desc "Transporter used to send sing-box logs to seq"
  homepage "https://github.com/moonfruit/sing2seq"
  url "https://github.com/moonfruit/sing2seq/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "91a1178b81adf1b5c6a089ce86c209f709e135f2ad8b2e98244e6a4b97903cfd"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "641b60f947e2fcb43d046322e2d314d77a9cb8cdd9cb79b4098c66628920610f"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "c07b43455bcf02bbe37d3c79411024dbc3cf5c85893fada875f66a12dee422e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a104d1fdd26badeae68f8551c9c6f2ad98f13497032e51c31cc50e3de885a312"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/sing2seq"
    generate_completions_from_executable(bin/"sing2seq", shell_parameter_format: :cobra)
  end

  test do
    assert_match "sing2seq version #{version}", shell_output("#{bin}/sing2seq --version")
  end
end
