class Seqcli < Formula
  desc "Seq command-line client"
  homepage "https://datalust.co/seq"
  url "https://github.com/datalust/seqcli/archive/refs/tags/v2026.1.02645.tar.gz"
  sha256 "01019d0f7de95993b680b7d80a83613181cf0ba39ab1c49f309c3aa787949d5b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:  "1f65f56b0f336e1b054daafd324a68c06aa5a0908ece64947679240a1cc7d683"
    sha256 cellar: :any, arm64_linux:  "d7ffbc5ad18fe65c43508351c60e8d5a0e7021b87a82436a0f354e3f310764b5"
    sha256 cellar: :any, x86_64_linux: "0d53d3560fe4ca19aea62b01ac4025d943b5cd9a27adb664c2c775dc3c9ea847"
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

    args = []
    # Remove once Homebrew/homebrew-core#305049 is merged: the x86_64 Linux `dotnet` bottle ships an
    # unstripped `singlefilehost`, which would add ~166 MiB of DWARF to the single-file binary.
    if OS.linux? && Hardware::CPU.intel?
      host_pack = formula_opt_libexec("dotnet").glob("packs/Microsoft.NETCore.App.Host.linux-x64/*").first
      cp host_pack/"runtimes/linux-x64/native/singlefilehost", buildpath
      system "strip", "--strip-debug", buildpath/"singlefilehost"
      args << "-p:SingleFileHostSourcePath=#{buildpath}/singlefilehost"
    end

    system "dotnet", "publish", "src/SeqCli/SeqCli.csproj",
           "--configuration", "Release",
           "--use-current-runtime",
           "--self-contained",
           "--output", buildpath/"dist",
           "-p:PublishSingleFile=true",
           "-p:Version=#{version}", *args

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
