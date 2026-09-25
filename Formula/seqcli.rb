class Seqcli < Formula
  desc "Seq command-line client"
  homepage "https://datalust.co/seq"
  url "https://github.com/datalust/seqcli/archive/refs/tags/v2026.1.02650.tar.gz"
  sha256 "7ef164a8414ddd716ba0765bea0ce005d57bfd14b29902585c6e4f76ed73ac53"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any, arm64_golden_gate: "24c55146cbb5cf0e8b9680a6a58a403b6c1ad97eaf8f33620fbea527ce113e35"
    sha256 cellar: :any, arm64_tahoe:       "81b573182a6217559e0b864d38b8604ca9f66a50903b53d3fdd674765ffe85be"
    sha256 cellar: :any, arm64_linux:       "22b49fb9a43cea3efe57940ee87d7ac2ea53bd1e59a71bd2adbf0d894e5175a7"
    sha256 cellar: :any, x86_64_linux:      "b0dd0c31429e3b6f8481f3e3ad46b4c738f38afa37c716eb9fbd0fde4aa010a4"
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
