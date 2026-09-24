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
    rebuild 2
    sha256 cellar: :any, arm64_golden_gate: "4a5f9387eea0547aa9649102c6c9f685bebeb050d0078c89540b2bfdefaba772"
    sha256 cellar: :any, arm64_tahoe:       "70b6812a9729c9ca482c09096bfc990dd638b344fc4ad62750662c2fc1617efb"
    sha256 cellar: :any, arm64_linux:       "0fbae166b1a0f2a1897b778ee2aba313d8f5aa02b888490cd5ecef128d99d3cf"
    sha256 cellar: :any, x86_64_linux:      "4aa27727afb4e2262192ad71c8fb2fae9e6bfbe3b85fc2c5b45dbabfe70aa709"
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
