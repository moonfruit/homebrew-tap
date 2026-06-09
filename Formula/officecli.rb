class Officecli < Formula
  desc "AI-friendly CLI for Office documents (.docx, .xlsx, .pptx)"
  homepage "https://officecli.ai"
  url "https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.105.tar.gz"
  sha256 "b24c29a219999f41dacfecaaf662dedb486f03ce7fc3d618a2408f0812c119e6"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any, arm64_tahoe:  "1c9cb859fdeb0b33155cd73f13e1a59018a388b0e1638667efe7a3b0a14bf63b"
    sha256 cellar: :any, arm64_linux:  "5504d91e3e5ae2bed3c4140733a8d97ec9848ff5ff5b66105657a80c1541ed5a"
    sha256               x86_64_linux: "382ac6dae5f4c66152404b71c053b3a4060e44c5dd4df8b4d5532ea44d22298f"
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
