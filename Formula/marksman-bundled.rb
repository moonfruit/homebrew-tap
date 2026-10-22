class MarksmanBundled < Formula
  desc "Language Server Protocol for Markdown"
  homepage "https://github.com/artempyanykh/marksman"
  url "https://github.com/artempyanykh/marksman/archive/refs/tags/2026-02-08.tar.gz"
  sha256 "a3ba5f8ef5be5d7ede2ec5ae9f303d2d776f476734ff66254be8e6df0e0f090e"
  license "MIT"
  head "https://github.com/artempyanykh/marksman.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    rebuild 2
    sha256 cellar: :any, arm64_golden_gate: "e223693d51b50d318118903f27891de8b0bd266b4f045fa005cc64b026bb9b38"
    sha256 cellar: :any, arm64_tahoe:       "7f80eb5225fc68b28b1acdc15fd2a3c6139733169847198cb77373c671cb9fa6"
    sha256 cellar: :any, arm64_linux:       "a61665302072349256f86327d28fa8db276792b1ab34106ced419bdecde06c72"
    sha256 cellar: :any, x86_64_linux:      "92baa22f919d57823288f8b47eb4c5311ef00a710222f6ce71e419a509c0169d"
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
    # .NET's user-scoped named mutexes need a writable runtime directory on Linux.
    ENV["XDG_RUNTIME_DIR"] = buildpath

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
