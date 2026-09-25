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
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "c0b5597eed704a289268f577a8dc2b990c495447b7474b04d6cd7dd99682bb04"
    sha256 cellar: :any, arm64_tahoe:       "5dfe28da33fbb1f2c06b426516ef48ace97738868ed4237d9b466eae529a8a46"
    sha256 cellar: :any, arm64_linux:       "659d9e7a5439c82a9ddc2fb8cd9b817475decc37417cc83664474a3220a62dd6"
    sha256 cellar: :any, x86_64_linux:      "56d6e6585b4c48181645aef4e1a5eabc42d3c54e65749705def485bd2a6af1d0"
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
