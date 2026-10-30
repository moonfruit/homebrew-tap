class Seqcli < Formula
  desc "Seq command-line client"
  homepage "https://datalust.co/seq"
  url "https://github.com/datalust/seqcli/archive/refs/tags/v2026.1.02662.tar.gz"
  sha256 "f4240b6d2ad245bf6b45d588bf4274c2e921730ebfb1b08bf21b1728f1873d41"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any, arm64_golden_gate: "32d0d87e1a5824ca9dda468d7240de83201b4668f50f098acd3aa74d6e21c55c"
    sha256 cellar: :any, arm64_tahoe:       "c531b5f7e1172958471e72ebd6d0a2d64b844d418087e3e02c40b1cc331ba4c2"
    sha256 cellar: :any, arm64_linux:       "6b6bb7238e72efc25b71790cede5bda0a21c52a5cd213a1b051458cf733fc74e"
    sha256 cellar: :any, x86_64_linux:      "fba94cd4777ffe1ba7051caa28ee5d6408507e37362b2739d963bd28e589f7b5"
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
