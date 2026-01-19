class SingBoxAT2 < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org/"
  url "https://github.com/SagerNet/sing-box/archive/refs/tags/v1.13.0-beta.7.tar.gz"
  sha256 "e331560c4b3a6be2e1be5a31932fb4a9b99086d56ff90959060b4c74e893f027"
  license "GPL-3.0-or-later"
  head "https://github.com/SagerNet/sing-box.git", branch: "dev-next"

  livecheck do
    url :stable
  end

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "94737f698e1e8a2df74b8d85402d9de4a8c72191b532194ba41dde6dd3f8ec32"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a13d03aaa3f4178ed8c4b5ea53031e0feaa0bd60d6783dbe2e5a7f8d1d4fade3"
  end

  keg_only :versioned_formula

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sagernet/sing-box/constant.Version=#{version} -buildid= -checklinkname=0"
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
