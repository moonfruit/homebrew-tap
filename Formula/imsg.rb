class Imsg < Formula
  desc "Send and read iMessage / SMS from the terminal"
  homepage "https://github.com/openclaw/imsg"
  url "https://github.com/openclaw/imsg/archive/refs/tags/v0.15.6.tar.gz"
  sha256 "f0df34e3a69f1e331fde285eaa99782c29520ef591a69f50fe16f0b70ba6d021"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    rebuild 1
    sha256 arm64_golden_gate: "a85dd04a64ed36ed61868036be98693f0fa141033f8bdd7e74bdae052726d384"
    sha256 arm64_tahoe:       "05e997d3cd6fd9b9a2ba2782e2da9ecdd4b6c9f86ed6750bdbe76595531af2d2"
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
