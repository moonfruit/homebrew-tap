class Seqcli < Formula
  desc "Seq command-line client"
  homepage "https://datalust.co/seq"
  url "https://github.com/datalust/seqcli/archive/refs/tags/v2026.2.02674.tar.gz"
  sha256 "b9d7c41a45a285d61f5a067d5dd605b45a90a9c97d542bdb83d25c8c27075a60"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0ccd7b87b65fe5543f094bba55ce52bae5370dae21b6f02af6c87aff2dcc282e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a9c9f6fba3f17c1fa522d0da4f7caf8a63242751fef14caf9791a0517fd8f59d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e04a7fc6634154ff1ef228f6f0f02a4cdbdea0ce6993609b0fc91cd758b48d3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "bc1f1b4a1c5a3c0cc959cc772b1191e1903c20181041cfd73561d44e809c2c93"
  end

  depends_on "dotnet" => :build
  depends_on "brotli"

  on_linux do
    depends_on "icu4c@78"
    depends_on "libunwind"
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    # .NET's user-scoped named mutexes need a writable runtime directory on Linux.
    ENV["XDG_RUNTIME_DIR"] = buildpath

    system "dotnet", "publish", "src/SeqCli/SeqCli.csproj",
           "--configuration", "Release",
           "--use-current-runtime",
           "--self-contained",
           "--output", buildpath/"dist",
           "-p:PublishSingleFile=true",
           "-p:Version=#{version}"

    libexec.install Dir[buildpath/"dist/*"]

    if OS.mac?
      bin.install_symlink libexec/"seqcli"
    else
      brew_libs = [
        formula_opt_lib("brotli"),
        formula_opt_lib("icu4c@78"),
        formula_opt_lib("openssl@3"),
      ].join(":")
      (bin/"seqcli").write_env_script libexec/"seqcli",
                                      LD_LIBRARY_PATH: "#{brew_libs}${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/seqcli version")
  end
end
