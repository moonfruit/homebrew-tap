class OfficecliBundled < Formula
  desc "AI-friendly CLI for Office documents (.docx, .xlsx, .pptx)"
  homepage "https://officecli.ai"
  url "https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.129.tar.gz"
  sha256 "256cceb57a59b4665957a075f5de37e0c40504dd2ffe77143b0c6e0b03cdc14f"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any, arm64_tahoe:  "11bff74a2e55250f678075a86c2a9e12ffa6ba1a940ad1c73703083e49a0fe5e"
    sha256 cellar: :any, arm64_linux:  "f7b08d39a0b363e0bc88fdb45c8bfe30a40de934174d15de609e6c94c4e5af7c"
    sha256               x86_64_linux: "7ebafa719830c6d3be91670730bf207e9ede3f990c6dc16e503e451195caadf7"
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
