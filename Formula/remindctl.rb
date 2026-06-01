class Remindctl < Formula
  desc "Fast CLI for Apple Reminders"
  homepage "https://github.com/openclaw/remindctl"
  url "https://github.com/openclaw/remindctl/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "360242b73cfca1cde5e5ab6cb8ceef1f91b61b7eae603c287ba56b3d70a24eda"
  license "MIT"

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
