class MacosTotpCli < Formula
  desc "Simple TOTP CLI, powered by keychain of macOS"
  homepage "https://github.com/simnalamburt/macos-totp-cli"
  url "https://github.com/simnalamburt/macos-totp-cli/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "82cc7c7798de320dd23b91c7fcdc76bfc3b4b60184397a5b25f025e639cfee3c"
  license any_of: ["Apache-2.0", "MIT"]
  revision 2

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36ba0372175b80bd80e6eee17057834e47d274e897f2e6c550e14d88967dd1a9"
    sha256 cellar: :any_skip_relocation, ventura:       "e620a7484422ee383e15d8ebceae68567d8bd23cb9a04a48c76ce6faf52d430b"
  end

  depends_on "go" => :build
  depends_on :macos

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: "totp")
    bin.install "totp"
    ENV.prepend_path "PATH", bin
    generate_completions_from_executable("totp", "completion", base_name: "totp")
  end

  test do
    system "#{bin}/totp", "--version"
  end
end
