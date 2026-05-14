class Officecli < Formula
  desc "AI-friendly CLI for Office documents (.docx, .xlsx, .pptx)"
  homepage "https://officecli.ai"
  url "https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.91.tar.gz"
  sha256 "7c7e0e1706ebd4a5b29bcd813788e482132abad13b202f8f5cfc0746ff08173a"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any,                 arm64_tahoe:  "7ad8835b60a41417472b0fa91025a206f8c3c9ea1431741a0cf7331194cb0e91"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "f9e6506fe9c9f1d17ec68e3fddc32a6dcd834edd286594f5d5c44613bbeba916"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7c96dd60a947a1461e606afa9b3d660f99adfc190c68ac50f07844136c8064ae"
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
