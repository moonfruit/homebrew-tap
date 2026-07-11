class SingBoxBeta < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org/"
  url "https://github.com/SagerNet/sing-box/archive/refs/tags/v1.14.0-alpha.43.tar.gz"
  sha256 "4a147867e5fbbecc263b6c301cebae74e301789b9501137c9c5b2450393b1653"
  license "GPL-3.0-or-later"
  head "https://github.com/SagerNet/sing-box.git", branch: "dev-next"

  livecheck do
    url :stable
  end

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "b44e97a91e47410289e2476ac533cbf54e54d74ea7ef42379bbac21407600134"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "f7fcd5b93c83d467f7eed099429f8fe5d835e29ba3432f941643a48bdeacd974"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "27e9047f26a043a8f35f4be885e12f965ffb5b23fdfeb6258b78fb2ad8b07872"
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
