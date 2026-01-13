class SingBoxRef1nd < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org/"
  url "https://github.com/reF1nd/sing-box/archive/refs/tags/v1.13.0-beta.4-reF1nd.tar.gz"
  version "1.13.0-beta.4-reF1nd"
  sha256 "39ff2d9cfefc2a1558e781f967ee9103c77fc9b73192de4c0bbea5adaee4486c"
  license "GPL-3.0-or-later"
  head "https://github.com/SagerNet/sing-box.git", branch: "dev-next"

  livecheck do
    url :stable
    regex(/^v(\d(?:\.\d+)+(-\w+(?:\.\d+)?)?-reF1nd(?:\.\d+)?)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "df9c99c5556123367672c7bef538d70e5b2ab24d96e5fe2f7f8de67fba06ce19"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e77b847ac06519e3f10c4f62753f374caea0ec5b98bf24523349b0aeae40a681"
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
