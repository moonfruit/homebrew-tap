class Seqcli < Formula
  desc "Seq command-line client"
  homepage "https://datalust.co/seq"
  url "https://github.com/datalust/seqcli/archive/refs/tags/v2026.1.02616.tar.gz"
  sha256 "fb35351a8a40ea0443310d2b9305b8d26d8792d2b5eaadf20a01f85303495bb3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any, arm64_tahoe:  "d1dc9d611831f07142316de4b4ea6df898925f50bf6a2951d0a1e99d2c0d470b"
    sha256 cellar: :any, arm64_linux:  "ed5b5c57478d1bd2853ea9e552be0ec29cbe32d82b571ae1d28b721749c437d8"
    sha256               x86_64_linux: "310a26406254f2b05d0999dde235ff73cf0bb822d40548fcb1687cb97cf4ee24"
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
