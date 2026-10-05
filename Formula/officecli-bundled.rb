class OfficecliBundled < Formula
  desc "AI-friendly CLI for Office documents (.docx, .xlsx, .pptx)"
  homepage "https://officecli.ai"
  url "https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.154.tar.gz"
  sha256 "82c84cfec2f9679ba3a575033bda46612856a517984dd0d3e529165e09cb1c1f"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any, arm64_golden_gate: "5419c7300a3be1cceeb20bb8cbc66dcc1ffcb72d4b437b3726bee2698e44528a"
    sha256 cellar: :any, arm64_tahoe:       "4526b7267fe3f52c99ee07d89b53f75e3f985e6956373db8404f6815444cbc0d"
    sha256 cellar: :any, arm64_linux:       "6770ff8555613dcd3b4ef384d6ac616da4ea6c8015285655276147a32728ab91"
    sha256 cellar: :any, x86_64_linux:      "0193dfe17a4d1e3b03f76e6b5f6b85c34ed6871e073c174427795247279c4144"
  end

  depends_on "dotnet" => :build
  depends_on "brotli"

  on_linux do
    depends_on "icu4c@78"
    depends_on "libunwind"
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"
  end

  conflicts_with "officecli", because: "both install an `officecli` binary"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"

    dotnet = Formula["dotnet"]
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os = OS.mac? ? "osx" : "linux"

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --runtime #{os}-#{arch}
      --self-contained
      --output #{buildpath}/dist
      -p:Version=#{version}
    ]

    system "dotnet", "publish", "src/officecli/officecli.csproj", *args

    if OS.mac?
      bin.install buildpath/"dist/officecli"
    else
      libexec.install buildpath/"dist/officecli"
      brew_libs = [
        formula_opt_lib("brotli"),
        formula_opt_lib("icu4c@78"),
        formula_opt_lib("openssl@3"),
      ].join(":")
      (bin/"officecli").write_env_script libexec/"officecli",
                                         LD_LIBRARY_PATH: "#{brew_libs}${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/officecli --version")
    system bin/"officecli", "create", "test.docx"
    assert_path_exists testpath/"test.docx"
    system bin/"officecli", "add", "test.docx", "/body", "--type", "paragraph", "--prop", "text=Hello from Homebrew"
    output = shell_output("#{bin}/officecli view test.docx text --json")
    assert_match "Hello from Homebrew", output
  end
end
