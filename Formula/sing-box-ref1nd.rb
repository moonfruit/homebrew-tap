class SingBoxRef1nd < Formula
  desc "Universal proxy platform"
  homepage "https://github.com/moonfruit/sing-box"
  url "https://github.com/moonfruit/sing-box/archive/refs/tags/v1.15.0-alpha.2-reF1nd-moonfruit.tar.gz"
  version "1.15.0-alpha.2-reF1nd-moonfruit"
  sha256 "80e72299e91461c0a13ecf4950f9670dcfda6cb1611b337c746d85e50f97c2d0"
  license "GPL-3.0-or-later"
  head "https://github.com/moonfruit/sing-box.git", branch: "moonfruit"

  livecheck do
    url :stable
    regex(/^v(\d(?:\.\d+)+(-\w+(?:\.\d+)?)?-reF1nd(?:\.\d+)?-moonfruit(?:\.\d+)?)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "f2e6f605afe0f206d19d0f5dc8f0c1f4b3735be2fdce217c2fcba90e180fdfa5"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "2a292af4061eb39e2b8506c38d7a6a6ee1f21078947566f6b698a466c636c778"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8e2e2ea93d298f995a3e9f0fe7972028f6e5a2e86c4556827e607df769999153"
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
