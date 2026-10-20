class OfficecliBundled < Formula
  desc "AI-friendly CLI for Office documents (.docx, .xlsx, .pptx)"
  homepage "https://officecli.ai"
  url "https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.158.tar.gz"
  sha256 "5a5e7c3b84384e5db6519f0db4946f58aacb7359ff031ea52c127bbe1e7f0bc9"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any, arm64_golden_gate: "d6ea2dfd0a4fa7d8b04d8068360f4cb806799fdef230921c9900e7feaae8c153"
    sha256 cellar: :any, arm64_tahoe:       "a19de906af99b8d7d09404283c1f48a8d4f080e5a32475d29a0dfbcaf94dcdde"
    sha256 cellar: :any, arm64_linux:       "3bdcf68cd008a1d5b9fe26b71a0c3780eeeb56449659e21fe2abc949b3f408eb"
    sha256 cellar: :any, x86_64_linux:      "d51f6521105e7c58baad023fd39e90a1b892693e20048c0f2599137965a23aba"
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
