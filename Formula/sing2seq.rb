class Sing2seq < Formula
  desc "Transporter used to send sing-box logs to seq"
  homepage "https://github.com/moonfruit/sing2seq"
  url "https://github.com/moonfruit/sing2seq/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "89920c783f9ee9ff5914b72c48ab8e68430f88911bb5a45573ae86e32a1b01e1"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "d0b7b541dca898bc154ae45564f827a76ef9da7d64a3bc5919988fc33999530d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "900a35364f24f860051f3d1f741d610229c27ac9a312a464462ad98a7bfc5d89"
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
