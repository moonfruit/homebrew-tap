class OfficecliBundled < Formula
  desc "AI-friendly CLI for Office documents (.docx, .xlsx, .pptx)"
  homepage "https://officecli.ai"
  url "https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.151.tar.gz"
  sha256 "ba46d6c5a46a3c69433a550fa5d2e2cf1b44e3c09cfc84fe09b68261b8459912"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "1df8749867688346bb6e7c2d43baa73364b3e35a3e68612d9fd7010ea6b6616d"
    sha256 cellar: :any, arm64_tahoe:       "a88016e8ef95719ab2f4e5169ae2e4b00c7b05987859443d2b395a0a38d19544"
    sha256 cellar: :any, arm64_linux:       "1489f1402c3cb0d521e666bcf806e55cb59bec5d2c027129f6f760cbaa9daf82"
    sha256 cellar: :any, x86_64_linux:      "48fc2802a77a1eeb6674694a474d075215d33cb9d942000117f55e32a8b31375"
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
