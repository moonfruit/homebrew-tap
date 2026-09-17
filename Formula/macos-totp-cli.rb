class MacosTotpCli < Formula
  desc "Simple TOTP CLI, powered by keychain of macOS"
  homepage "https://github.com/simnalamburt/macos-totp-cli"
  url "https://github.com/simnalamburt/macos-totp-cli/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "c70057bfc159e79509c46ffa33af460844b7a1733765a22c4ac5faf6e20fdf10"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e54e9591025c487b41cc93a72e0e69c9dd11b5973dfbee933cd66cb604197767"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "91577b3ca57003721279246c17af284d4455b8ebf9a601daeb79b2899d91d589"
  end

  depends_on "go" => :build
  depends_on :macos

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"totp")
    generate_completions_from_executable(bin/"totp", shell_parameter_format: :cobra)
  end

  test do
    system "#{bin}/totp", "--version"
  end
end
