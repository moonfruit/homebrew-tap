class OfficecliBundled < Formula
  desc "AI-friendly CLI for Office documents (.docx, .xlsx, .pptx)"
  homepage "https://officecli.ai"
  url "https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.163.tar.gz"
  sha256 "740ceebf57b6476129afb001f5c962e1321416ab5f395eed62ef63d2963de3f7"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any, arm64_golden_gate: "c29210c8ab91db7ae35ebd88a81e948410f830e03551456b5b64a719e52ec34f"
    sha256 cellar: :any, arm64_tahoe:       "a2003b39b258b9d18e6925958ed4a560e6ead399a236ecfb1c8ccea10f675716"
    sha256 cellar: :any, arm64_linux:       "fbbb2cd180fc6e9090b3cb9b57eed3202ed81bcde881d050c2a46fc7fb6cd370"
    sha256 cellar: :any, x86_64_linux:      "6e33372cee92d3c6dd366cd17f304ecc2d122f0448378e2e4ade361cd363a497"
  end

  depends_on "dotnet@10" => :build
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
    # .NET's user-scoped named mutexes need a writable runtime directory on Linux.
    ENV["XDG_RUNTIME_DIR"] = buildpath

    dotnet = Formula["dotnet@10"]
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
