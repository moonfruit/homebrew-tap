class Imsg < Formula
  desc "Send and read iMessage / SMS from the terminal"
  homepage "https://github.com/openclaw/imsg"
  url "https://github.com/openclaw/imsg/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "42c505e0b480fb5b48744a88ab86f11e6ca2e3a6705cf7b639234b625bc695d8"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 arm64_golden_gate: "2d28e71e43394a360d0789f51ff4783e87c2777de69ba77a93c377bb5112998d"
    sha256 arm64_tahoe:       "200e77a05dd0aeee810900ce6a32f2efbaa42128772ea6191cf1a5c933828e5a"
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
