class MacosTotpCli < Formula
  desc "Simple TOTP CLI, powered by keychain of macOS"
  homepage "https://github.com/simnalamburt/macos-totp-cli"
  url "https://github.com/simnalamburt/macos-totp-cli/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "62f6febc7c5d6d6892d07aa39e383c2c4a26dcf985a00f89728b27983ee27079"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "135fc04f25b7386b753334b2f1594d704503f7ebb68c10b3be1bccdc3131916a"
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
