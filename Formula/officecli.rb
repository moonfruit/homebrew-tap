class Officecli < Formula
  desc "AI-friendly CLI for Office documents (.docx, .xlsx, .pptx)"
  homepage "https://officecli.ai"
  url "https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.90.tar.gz"
  sha256 "2a11b840aeda036ae4dd891b87ee45525f1a733a0b431b0ff6a476dbc1c20708"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any,                 arm64_tahoe:  "69b83f390fa7204dbeb11328c7e4c6a9f720923ce14bb54718fb4c039e251b73"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "4e1cc1a0ac9692222192cf08ec0613b6ff2695a6347493de63ab20af98f34915"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b28c0284f496ab14507c16b4e982d6f94fc370ee389fd7583b16bce0cb967a21"
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
