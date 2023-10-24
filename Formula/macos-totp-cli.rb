class MacosTotpCli < Formula
  desc "Simple TOTP CLI, powered by keychain of macOS"
  homepage "https://github.com/simnalamburt/macos-totp-cli"
  url "https://github.com/simnalamburt/macos-totp-cli/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "afb947ac9b0cb227a302e81f6faf1f9c8bbadc169bba2445d9104cbb7200eeb2"
  license any_of: ["Apache-2.0", "MIT"]

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-o", "totp"
    bin.install "totp"
    ENV["PATH"] = "#{bin}:#{ENV["PATH"]}"
    generate_completions_from_executable("totp", "completion", base_name: "totp")
  end

  test do
    system "#{bin}/totp", "--version"
  end
end
