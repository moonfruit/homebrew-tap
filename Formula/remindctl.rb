class Remindctl < Formula
  desc "Fast CLI for Apple Reminders"
  homepage "https://github.com/openclaw/remindctl"
  url "https://github.com/openclaw/remindctl/archive/refs/tags/v0.3.7.tar.gz"
  sha256 "989a353f4d9d5f822cee00fc1e030d71387a38ce02c5697e209ffde38d4533e5"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "969fccdacd4dfae3f05dd8798dc26013c1e8a20a9b0110b0c06ae2ce800d5228"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "01dd1acedac398d9df27c1e340ed39fa705b77822123e6d3a252f7df27f7d9a6"
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
