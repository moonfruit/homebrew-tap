class Sing2seq < Formula
  desc "Transporter used to send sing-box logs to seq"
  homepage "https://github.com/moonfruit/sing2seq"
  url "https://github.com/moonfruit/sing2seq/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "91a1178b81adf1b5c6a089ce86c209f709e135f2ad8b2e98244e6a4b97903cfd"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5325001d51a2e0ae11f81f54368edce7fa4804b91542ac59f6908dd3c591e8f0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cf26d6e85e21c6788b41ec976d4955d974aff6312a71b2e1133d7a630c30e394"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f159554bb375eac2b3450cf86e6a66c440c52debfbf9d43d7581da2ec5374252"
    sha256 cellar: :any,                 x86_64_linux:      "06e1c736c72b971de3a6aaa549ff2e5710828358db26ecc0c53af8cea64c6d7a"
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
