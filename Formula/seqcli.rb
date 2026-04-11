class Seqcli < Formula
  desc "Seq command-line client"
  homepage "https://datalust.co/seq"
  url "https://github.com/datalust/seqcli/archive/refs/tags/v2025.2.02473.tar.gz"
  sha256 "0e52768d85fb6495c59a30dd308522a2a3c3f38b30985ed21fc3b1c9037ea326"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "a79d435a4f7892fed021843ae41b0516e7bc17c2e39fb10a4daed57cd4799cf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4f96353057165c4ad3e17f0b9511a7293399ab3bb3597ae73d5e9b8ce9545235"
  end

  depends_on "dotnet"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"

    dotnet = Formula["dotnet"]

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
      -p:PublishSingleFile=true
      -p:Version=#{version}
    ]

    system "dotnet", "publish", "src/SeqCli/SeqCli.csproj", *args

    (bin/"seqcli").write_env_script libexec/"seqcli", DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/seqcli version")
  end
end
