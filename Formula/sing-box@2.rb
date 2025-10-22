class SingBoxAT2 < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org/"
  url "https://github.com/SagerNet/sing-box/archive/refs/tags/v1.13.0-alpha.24.tar.gz"
  sha256 "7ca4474559d154957c025e78781b37999f10a9f09eaefa94a44ce2c3f7b49c77"
  license "GPL-3.0-or-later"
  head "https://github.com/SagerNet/sing-box.git", branch: "dev-next"

  livecheck do
    url :stable
  end

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "21e012d129e6a00eb8127b664d6807fe577c42fd2f504a19fa19f352c37f96f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7309d48e7bb4c182e201f7791c0412283bb227ce33b35fb91d18731e6e2e70dc"
  end

  keg_only :versioned_formula

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sagernet/sing-box/constant.Version=#{version} -buildid= -checklinkname=0"
    tags = %w[
      with_acme
      with_clash_api
      with_dhcp
      with_gvisor
      with_quic
      with_tailscale
      with_utls
      with_wireguard
      badlinkname
      tfogo_checklinkname0
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"sing-box", tags: tags.join(",")), "./cmd/sing-box"
    generate_completions_from_executable(bin/"sing-box", "completion")
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
