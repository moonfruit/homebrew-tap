class Officecli < Formula
  desc "AI-friendly CLI for Office documents (.docx, .xlsx, .pptx)"
  homepage "https://officecli.ai"
  url "https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.103.tar.gz"
  sha256 "1bc84199f89c27b5ebea0395f5c3cd679ac90253ad205f571bcae01767476894"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any,                 arm64_tahoe:  "076e04bc3bff5b4fa23cf4847dfb5193f343792cc57599b16ef1ad4d6d410277"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "cc2ce3618be405c8922fe7086ad73839eeda46bda429024fb49929b1e299004e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4da969dc7264e136ef739e411a86b682e2ac288f3447db1eb428c12b2b40f831"
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
