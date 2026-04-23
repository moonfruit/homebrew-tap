class SingBoxRef1nd < Formula
  desc "Universal proxy platform"
  homepage "https://sing-boxr.dustinwin.us.kg/"
  url "https://github.com/reF1nd/sing-box/archive/refs/tags/v1.14.0-alpha.16-reF1nd.tar.gz"
  version "1.14.0-alpha.16-reF1nd"
  sha256 "cf7a5becee70ef600270859d4cafebde2119cb6ccf6bd414870c682a247637c0"
  license "GPL-3.0-or-later"
  head "https://github.com/reF1nd/sing-box.git", branch: "reF1nd-dev-next"

  livecheck do
    url :stable
    regex(/^v(\d(?:\.\d+)+(-\w+(?:\.\d+)?)?-reF1nd(?:\.\d+)?)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "9fd6b93e8be70b18122d863367239c653472c0a27880334c952cd9ca39ac97a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a2fdb07264403511591af110ae0c87b7025bce419f7ef9b4d2b00887d771bd46"
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
