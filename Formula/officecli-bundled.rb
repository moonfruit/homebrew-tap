class OfficecliBundled < Formula
  desc "AI-friendly CLI for Office documents (.docx, .xlsx, .pptx)"
  homepage "https://officecli.ai"
  url "https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.152.tar.gz"
  sha256 "99f8ec827063398dd226169498fb7ecd28d958c82210f81c2fd73765ed6af196"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any, arm64_golden_gate: "e0929458fd044940b17f1e7e7f17462b9d8e9d20425b08457c89632ebfa66923"
    sha256 cellar: :any, arm64_tahoe:       "5b3801a3b15827be45146fbf0a66e275710b32d48c0137cde5a4a0f947befc81"
    sha256 cellar: :any, arm64_linux:       "1d1d296302bd2cba869f66f89c6f04cfddd9254b9b58dcda8e73dc4ef6d51d89"
    sha256 cellar: :any, x86_64_linux:      "75bb75907ec1937f93597768523e7eb3c72cb3c3791f5be8925b8b4d34b4915b"
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
