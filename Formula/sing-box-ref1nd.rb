class SingBoxRef1nd < Formula
  desc "Universal proxy platform"
  homepage "https://github.com/moonfruit/sing-box"
  url "https://github.com/moonfruit/sing-box/archive/refs/tags/v1.15.0-alpha.11-reF1nd-moonfruit.tar.gz"
  version "1.15.0-alpha.11-reF1nd-moonfruit"
  sha256 "1dce34cb01f21a06a4e3706675d5e6260d720ec1c910799ab727ae1ba89475a4"
  license "GPL-3.0-or-later"
  head "https://github.com/moonfruit/sing-box.git", branch: "moonfruit"

  livecheck do
    url :stable
    regex(/^v(\d(?:\.\d+)+(-\w+(?:\.\d+)?)?-reF1nd(?:\.\d+)?-moonfruit(?:\.\d+)?)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "95ac5c0ab4279a511c307637563a2f7afd6522067f42626c62b698e517e82a82"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b6fb691383fa9ba3d8637fac85e7c8a5b2e74535826780e924c8f07c12479181"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e69058a167dd6f7053b8d9537821d753bdc58662fd25be81ea0c7d54e1e7e116"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "d57fe1c4f522054c5cab9122cde9ee6e9ea4f4a5260c5f0f3b092b38e0dcdaad"
  end

  keg_only :versioned_formula

  depends_on "go@1.26" => :build

  on_linux do
    depends_on "lld" => :build
    depends_on "llvm" => :build
  end

  def install
    tags = File.read("release/DEFAULT_BUILD_TAGS").strip.split(",")
    ldflags_shared = File.read("release/LDFLAGS").strip

    if OS.linux?
      ENV["CC"] = formula_opt_bin("llvm")/"clang"
      ENV["CXX"] = formula_opt_bin("llvm")/"clang++"
      ENV["CGO_ENABLED"] = "1"
      ENV.append "CGO_LDFLAGS", "-fuse-ld=#{formula_opt_bin("lld")}/ld.lld"
    end

    ldflags = "-s -w -X github.com/sagernet/sing-box/constant.Version=#{version} #{ldflags_shared} -buildid="
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
    server = spawn bin/"sing-box", "run", "-D", testpath, "-c", testpath/"shadowsocks.json"

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
    client = spawn bin/"sing-box", "run", "-D", testpath, "-c", "config.json"

    begin
      sleep 3
      system "curl", "--socks5", "127.0.0.1:#{sing_box_port}", "github.com"
    ensure
      Process.kill "TERM", server
      Process.kill "TERM", client
      Process.wait server
      Process.wait client
    end
  end
end
