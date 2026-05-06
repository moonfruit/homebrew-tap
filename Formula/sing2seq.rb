class Sing2seq < Formula
  desc "Transporter used to send sing-box logs to seq"
  homepage "https://github.com/moonfruit/sing2seq"
  url "https://github.com/moonfruit/sing2seq/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "91a1178b81adf1b5c6a089ce86c209f709e135f2ad8b2e98244e6a4b97903cfd"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "38242cb1bcab8b7793ace7dc3237669eb63fab80b779721a048b66ae9ce361b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3af2e1f67d6bcd298a37db435a0c24cef6a1bf69005a940fd2091afb7687d574"
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
