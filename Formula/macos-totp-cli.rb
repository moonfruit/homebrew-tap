class MacosTotpCli < Formula
  desc "Simple TOTP CLI, powered by keychain of macOS"
  homepage "https://github.com/simnalamburt/macos-totp-cli"
  url "https://github.com/simnalamburt/macos-totp-cli/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "82cc7c7798de320dd23b91c7fcdc76bfc3b4b60184397a5b25f025e639cfee3c"
  license any_of: ["Apache-2.0", "MIT"]
  revision 2

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "6b0c4afdea9931590e38b06b7c063b4857e97b34bcba373edd626a72cfc48583"
    sha256 cellar: :any_skip_relocation, ventura:     "217241fc6800252c18d47d44ad8a9d07aaad462d72c6b0a9e15b01f0a0d2e5f0"
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
