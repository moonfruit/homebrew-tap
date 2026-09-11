class OfficecliBundled < Formula
  desc "AI-friendly CLI for Office documents (.docx, .xlsx, .pptx)"
  homepage "https://officecli.ai"
  url "https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.149.tar.gz"
  sha256 "7a4ca4c0e91318d7782ece14e0386fee967d6a221ead9ce3fd7d7c1f99cb7b6e"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:  "e212078b022d60b42a826af7dcce7c2a49115e4456f650a5e702cef93b182978"
    sha256 cellar: :any, arm64_linux:  "eecc51327e79e6ad1a6d00b6eb276870626fc36480026fe667dd8de1e14a78f5"
    sha256 cellar: :any, x86_64_linux: "9f034dc77a6e16a3734c4e7b77098120ec7f8ba33c4ea8190f13e94e8d0b9a4d"
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

    # Remove once Homebrew/homebrew-core#305049 is merged: the x86_64 Linux `dotnet` bottle ships an
    # unstripped `singlefilehost`, which would add ~166 MiB of DWARF to the single-file binary.
    if OS.linux? && Hardware::CPU.intel?
      host_pack = dotnet.opt_libexec.glob("packs/Microsoft.NETCore.App.Host.linux-x64/*").first
      cp host_pack/"runtimes/linux-x64/native/singlefilehost", buildpath
      system "strip", "--strip-debug", buildpath/"singlefilehost"
      args << "-p:SingleFileHostSourcePath=#{buildpath}/singlefilehost"
    end

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
