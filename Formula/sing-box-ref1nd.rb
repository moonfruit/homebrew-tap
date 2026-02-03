class SingBoxRef1nd < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org/"
  url "https://github.com/reF1nd/sing-box/archive/refs/tags/v1.13.0-rc.1-reF1nd.tar.gz"
  version "1.13.0-rc.1-reF1nd"
  sha256 "e08fe406be884e207969b8f89523c799895c4a3d3eb1ac8dd3781009e7576c18"
  license "GPL-3.0-or-later"
  head "https://github.com/SagerNet/sing-box.git", branch: "dev-next"

  livecheck do
    url :stable
    regex(/^v(\d(?:\.\d+)+(-\w+(?:\.\d+)?)?-reF1nd(?:\.\d+)?)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "7998e55329a8e37ece72bd0d1af97ca4810e49dc0a62faf8a4df3909d0f427f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a5be06b7eb05f45f32c2ec15508001c6ef417cc94a037316e6234a8805492d1f"
  end

  keg_only "it conflicts with sing-box"

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/sagernet/sing-box/constant.Version=#{version} -s -w -buildid= -checklinkname=0"
    tags = %w[
      with_acme
      with_ccm
      with_clash_api
      with_dhcp
      with_gvisor
      with_ocm
      with_quic
      with_tailscale
      with_utls
      with_wireguard
      badlinkname
      tfogo_checklinkname0
    ]
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
