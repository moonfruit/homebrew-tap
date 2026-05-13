class Officecli < Formula
  desc "AI-friendly CLI for Office documents (.docx, .xlsx, .pptx)"
  homepage "https://officecli.ai"
  url "https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.89.tar.gz"
  sha256 "900d264455339660b0de9b809a664373cfd1961ea9ca87fa93aed71fa210dbe8"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any,                 arm64_tahoe:  "57a233da863a41a4410ba2f09a1752be8093df3ee4004eba6b80c271b90a8f46"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "95c82ba741ad1a189a8b61709ea55c54bf7202b432084db985c917f3eff46fe1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1737f56c798050178d4c59e96b3aae1d05a48274ee42863de73bdb8dfc9bd188"
  end

  depends_on "dotnet" => :build
  depends_on "brotli"

  on_linux do
    depends_on "icu4c@78"
    depends_on "openssl@3"
  end

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"

    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os = OS.mac? ? "osx" : "linux"

    system "dotnet", "publish", "src/officecli/officecli.csproj",
           "--configuration", "Release",
           "--runtime", "#{os}-#{arch}",
           "--output", buildpath/"dist"

    if OS.mac?
      bin.install buildpath/"dist/officecli"
    else
      libexec.install buildpath/"dist/officecli"
      brew_libs = [
        Formula["brotli"].opt_lib,
        Formula["icu4c@78"].opt_lib,
        Formula["openssl@3"].opt_lib,
      ].join(":")
      (bin/"officecli").write_env_script libexec/"officecli",
                                         LD_LIBRARY_PATH: "#{brew_libs}${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/officecli --version")
  end
end
