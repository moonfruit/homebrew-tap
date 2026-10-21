class OfficecliBundled < Formula
  desc "AI-friendly CLI for Office documents (.docx, .xlsx, .pptx)"
  homepage "https://officecli.ai"
  url "https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.158.tar.gz"
  sha256 "5a5e7c3b84384e5db6519f0db4946f58aacb7359ff031ea52c127bbe1e7f0bc9"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any, arm64_golden_gate: "7795e80f65be2c351570fc0a34dfc57ac2790c79fab7d2861c081ea1ed9cf382"
    sha256 cellar: :any, arm64_tahoe:       "55404192c260a5da779705fb4415edb43fa9e1f5d9028d12f52b474bf1abddfa"
    sha256 cellar: :any, arm64_linux:       "68ec303884bcc045aa2d2caef24d4f18c2057e21b5e929ce1b435b75f66dc69e"
    sha256 cellar: :any, x86_64_linux:      "4e5d9616035763b7fc8ddbfc66b4ccb8b1f01ad74033ae88af9f76ad0e2efa80"
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
    # .NET's user-scoped named mutexes need a writable runtime directory on Linux.
    ENV["XDG_RUNTIME_DIR"] = buildpath

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
