class SingBoxRef1nd < Formula
  desc "Universal proxy platform"
  homepage "https://github.com/moonfruit/sing-box"
  url "https://github.com/moonfruit/sing-box/archive/refs/tags/v1.14.0-beta.15-reF1nd-moonfruit.tar.gz"
  version "1.14.0-beta.15-reF1nd-moonfruit"
  sha256 "1a89ddefa5c68fa72aca399ac7ae40875cc3371f59266a9c58253701395ac4de"
  license "GPL-3.0-or-later"
  head "https://github.com/moonfruit/sing-box.git", branch: "moonfruit"

  livecheck do
    url :stable
    regex(/^v(\d(?:\.\d+)+(-\w+(?:\.\d+)?)?-reF1nd(?:\.\d+)?-moonfruit(?:\.\d+)?)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "16fd5c614b7e62c20435b05d79dd21bc9ebcf97f5c587dedee998bdc8681225a"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "61494bbf353b131d431444317c3d68424b6570d189ff63d7926bc2c41804b601"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6b6fb8cec9655a45488ca4dca3670bfc96af9be504c18b069f1e2174df7ce692"
  end

  keg_only :versioned_formula

  depends_on "go" => :build

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
      ENV["CGO_LDFLAGS"] = "-fuse-ld=#{formula_opt_bin("lld")}/ld.lld"
    end

    ldflags = "-s -w -X github.com/sagernet/sing-box/constant.Version=#{version} #{ldflags_shared} -buildid="
    system "go", "build", *std_go_args(ldflags:, output: bin/"sing-box", tags:), "./cmd/sing-box"
    generate_completions_from_executable(bin/"sing-box", shell_parameter_format: :cobra)

    system bin/"sing-box", "schema", "-o", buildpath/"schema.json"
    pkgshare.install "schema.json"
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
