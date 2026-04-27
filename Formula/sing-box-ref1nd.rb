class SingBoxRef1nd < Formula
  desc "Universal proxy platform"
  homepage "https://sing-boxr.dustinwin.us.kg/"
  url "https://github.com/reF1nd/sing-box/archive/refs/tags/v1.14.0-alpha.18-reF1nd.tar.gz"
  version "1.14.0-alpha.18-reF1nd"
  sha256 "7d306859202f0c61b83911bd0c08109698e77a63ba25461653ebce13c76e4496"
  license "GPL-3.0-or-later"
  head "https://github.com/reF1nd/sing-box.git", branch: "reF1nd-dev-next"

  livecheck do
    url :stable
    regex(/^v(\d(?:\.\d+)+(-\w+(?:\.\d+)?)?-reF1nd(?:\.\d+)?)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "23d1e6bbcd70c285040a22e952b2fc5add54cf343467a28c0094d6c6b6fcf8cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "cdf22e1d8e2b0d0d9d4e4399fec6db523a46bf4a0f891481d956a7d5b8aaaa32"
  end

  keg_only :versioned_formula

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/sagernet/sing-box/constant.Version=#{version} " \
              "#{(buildpath/"release/LDFLAGS").read.strip} -s -w -buildid="
    tags = (buildpath/"release/DEFAULT_BUILD_TAGS_OTHERS").read.strip
    system "go", "build", *std_go_args(ldflags:, output: bin/"sing-box", tags:), "./cmd/sing-box"
    generate_completions_from_executable(bin/"sing-box", shell_parameter_format: :cobra)
  end

  service do
    run [opt_bin/"sing-box", "run", "--config", etc/"sing-box/config.json", "--directory", var/"lib/sing-box"]
    run_type :immediate
    keep_alive true
  end

  test do
    ss_port = free_port
    (testpath/"shadowsocks.json").write <<~JSON
      {
        "inbounds": [
          {
            "type": "shadowsocks",
            "listen": "::",
            "listen_port": #{ss_port},
            "method": "2022-blake3-aes-128-gcm",
            "password": "8JCsPssfgS8tiRwiMlhARg=="
          }
        ]
      }
    JSON
    server = fork { exec bin/"sing-box", "run", "-D", testpath, "-c", testpath/"shadowsocks.json" }

    sing_box_port = free_port
    (testpath/"config.json").write <<~JSON
      {
        "inbounds": [
          {
            "type": "mixed",
            "listen": "::",
            "listen_port": #{sing_box_port}
          }
        ],
        "outbounds": [
          {
            "type": "shadowsocks",
            "server": "127.0.0.1",
            "server_port": #{ss_port},
            "method": "2022-blake3-aes-128-gcm",
            "password": "8JCsPssfgS8tiRwiMlhARg=="
          }
        ]
      }
    JSON
    system bin/"sing-box", "check", "-D", testpath, "-c", "config.json"
    client = fork { exec bin/"sing-box", "run", "-D", testpath, "-c", "config.json" }

    sleep 3
    begin
      system "curl", "--socks5", "127.0.0.1:#{sing_box_port}", "github.com"
    ensure
      Process.kill 9, server
      Process.wait server
      Process.kill 9, client
      Process.wait client
    end
  end
end
