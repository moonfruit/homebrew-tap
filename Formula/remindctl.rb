class Remindctl < Formula
  desc "Fast CLI for Apple Reminders"
  homepage "https://github.com/openclaw/remindctl"
  url "https://github.com/openclaw/remindctl/archive/refs/tags/v0.3.8.tar.gz"
  sha256 "25a18712ae80580e854afe4fc5b6deedea3346000edf837b65d41f1f5abc1dee"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7b1beb208953a2c32b25707d66007a741fb434683a658c638ddeea1e9cba2209"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0cceede6db903c18b39c23e510cf1d629c3ce35760cec0b0451dfbb969dc99cd"
  end

  depends_on xcode: ["16.0", :build]
  depends_on :macos

  def install
    system "bash", "scripts/generate-version.sh"
    system "swift", "build", "--disable-sandbox", "-c", "release", "--product", "remindctl"
    bin.install ".build/release/remindctl"
  end

  def caveats
    <<~EOS
      remindctl needs Reminders access.
      System Settings > Privacy & Security > Reminders
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/remindctl --version")
    assert_match "Manage Apple Reminders", shell_output("#{bin}/remindctl --help")
  end
end
