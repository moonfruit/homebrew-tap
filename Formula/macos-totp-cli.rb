class MacosTotpCli < Formula
  desc "Simple TOTP CLI, powered by keychain of macOS"
  homepage "https://github.com/simnalamburt/macos-totp-cli"
  url "https://github.com/simnalamburt/macos-totp-cli/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "82cc7c7798de320dd23b91c7fcdc76bfc3b4b60184397a5b25f025e639cfee3c"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e1f0f2aa5b09d2591d07ccec9ad9457c22c5fcd346b5b569592c380567bc3fa"
  end

  depends_on "go" => :build
  depends_on :macos

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-o", "totp"
    bin.install "totp"
    ENV.prepend_path "PATH", bin
    generate_completions_from_executable("totp", "completion", base_name: "totp")
  end

  test do
    system "#{bin}/totp", "--version"
  end
end
