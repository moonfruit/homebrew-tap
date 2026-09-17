class MarksmanBundled < Formula
  desc "Language Server Protocol for Markdown"
  homepage "https://github.com/artempyanykh/marksman"
  url "https://github.com/artempyanykh/marksman/archive/refs/tags/2026-02-08.tar.gz"
  sha256 "a3ba5f8ef5be5d7ede2ec5ae9f303d2d776f476734ff66254be8e6df0e0f090e"
  license "MIT"
  head "https://github.com/artempyanykh/marksman.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:  "dde304864db7e598e6e2223b03f68564fa07ed5576e6ad30b4766e0e899fd8af"
    sha256 cellar: :any, arm64_linux:  "10b3b475516d2d248ae3e38a714ff3bdb0ebfa52721df5a70ed849054d7902b2"
    sha256 cellar: :any, x86_64_linux: "b8b6f57f1b6a3fd6970352a78d845e74e9a3427fac3dac431aeab9f41d5937d7"
  end

  depends_on "dotnet@9" => :build # https://github.com/artempyanykh/marksman/pull/446
  depends_on "brotli"

  on_linux do
    depends_on "icu4c@78"
    depends_on "libunwind"
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"
  end

  conflicts_with "marksman", because: "both install a `marksman` binary"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "true"

    dotnet = Formula["dotnet@9"]
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --self-contained
      --output #{libexec}
      --use-current-runtime
      -p:PublishSingleFile=true
      -p:PublishTrimmed=true
      -p:TrimMode=partial
      -p:DebugType=embedded
      -p:EnableCompressionInSingleFile=true
    ]
    args << "-p:VersionString=#{version}" if build.stable?

    system "dotnet", "publish", "Marksman/Marksman.fsproj", *args

    if OS.mac?
      bin.install_symlink libexec/"marksman"
    else
      brew_libs = [
        formula_opt_lib("brotli"),
        formula_opt_lib("icu4c@78"),
        formula_opt_lib("openssl@3"),
      ].join(":")
      (bin/"marksman").write_env_script libexec/"marksman",
                                        LD_LIBRARY_PATH: "#{brew_libs}${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
    end
  end

  test do
    require "open3"

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON

    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"

    Open3.popen3(bin/"marksman", "server") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"

      sleep 3

      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
