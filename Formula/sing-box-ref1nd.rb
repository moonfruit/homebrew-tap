class SingBoxRef1nd < Formula
  desc "Universal proxy platform"
  homepage "https://github.com/moonfruit/sing-box"
  url "https://github.com/moonfruit/sing-box/archive/refs/tags/v1.15.0-alpha.13-reF1nd-moonfruit.1.tar.gz"
  version "1.15.0-alpha.13-reF1nd-moonfruit.1"
  sha256 "14bcdad39e26cca36ee52a13534f0e2db0f6ae47d3ee672d9a0ccb11f1e7ddc7"
  license "GPL-3.0-or-later"
  head "https://github.com/moonfruit/sing-box.git", branch: "moonfruit"

  livecheck do
    url :stable
    regex(/^v(\d(?:\.\d+)+(-\w+(?:\.\d+)?)?-reF1nd(?:\.\d+)?-moonfruit(?:\.\d+)?)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "09c2ca477ec9a130715987cf12d466261b12e839814506164bcb9484cd02901a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "42f7fe7334c5932966f2e92256f7452a7aecba70b976874d768c59d4454a7149"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8711e2a8cdccf6f796e3fb4d05e8e41d539cb8d8bd76858887184a9addd252eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f470b6cc708efe7ce637e9a05d73e9fdb677856e406a7d0af252b82d04933d4e"
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
