class Remindctl < Formula
  desc "Fast CLI for Apple Reminders"
  homepage "https://github.com/openclaw/remindctl"
  url "https://github.com/openclaw/remindctl/archive/refs/tags/v0.3.9.tar.gz"
  sha256 "f3968efce8c80bf2b4031a50ad3bfdbcc055ec49afe5f1c5fba581596f8b4569"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8eda07af5b69c301a42d5b76ccf1e917c8b0fc0496c03fd9aedfb17e3df0b387"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0cb818f8dc88f1a246dd68a256fa3e87b7a7eb609ff32525cde71cd75985fd44"
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
