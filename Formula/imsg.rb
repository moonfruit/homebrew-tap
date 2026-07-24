class Imsg < Formula
  desc "Send and read iMessage / SMS from the terminal"
  homepage "https://github.com/openclaw/imsg"
  url "https://github.com/openclaw/imsg/archive/refs/tags/v0.13.3.tar.gz"
  sha256 "4b9f1a347ba0aaf9ab3b280e4962b401aae71b0a517a09ac507969c90c52c651"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 arm64_tahoe: "365625c77ffc1db4bb9410f44a82c11b20f0ca93d16ca082064fff2978ee8e01"
  end

  depends_on xcode: ["16.0", :build]
  depends_on :macos

  def install
    system "bash", "scripts/generate-version.sh"
    system "swift", "package", "--disable-sandbox", "resolve"
    system "bash", "scripts/patch-deps.sh"
    system "swift", "build", "--disable-sandbox", "-c", "release", "--product", "imsg"

    libexec.install ".build/release/imsg"
    Dir[".build/release/*.bundle"].each { |bundle| libexec.install bundle }

    if Hardware::CPU.arm?
      system ENV.cc, "-dynamiclib", "-arch", "arm64e", "-fobjc-arc",
             "-Wno-arc-performSelector-leaks",
             "-framework", "Foundation", "-framework", "AppKit",
             "-framework", "ImageIO", "-framework", "LinkPresentation",
             "-o", "imsg-bridge-helper.dylib",
             "Sources/IMsgHelper/IMsgInjected.m"
      libexec.install "imsg-bridge-helper.dylib"
    end

    bin.write_exec_script libexec/"imsg"
  end

  def caveats
    <<~EOS
      imsg needs Full Disk Access to read the Messages database.

      To grant permission:
      1. Open System Settings > Privacy & Security > Full Disk Access
      2. Enable access for your Terminal application

      To send messages, allow Terminal to control Messages.app:
      System Settings > Privacy & Security > Automation

      Advanced IMCore bridge features also require SIP disabled. The formula
      builds and installs the bridge helper automatically on Apple Silicon.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/imsg --version")
    assert_match "Send and read iMessage", shell_output("#{bin}/imsg --help")
  end
end
