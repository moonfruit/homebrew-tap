cask "macapk" do
  version "1.0.2404"
  sha256 "9ab3f8b1052867b5ebcbf95296491146f4dc5831bb64faf65eb2155d419626cb"

  url "https://github.com/kksimp/Mac.apk/releases/download/v#{version}/macapk.dmg"
  name "Mac.apk"
  desc "Run Android apps natively on Apple Silicon Macs"
  homepage "https://github.com/kksimp/Mac.apk"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: :tahoe

  app "Mac.apk.app"

  zap trash: [
    "~/Library/Application Support/Mac.apk",
    "~/Library/Application Support/MacApk",
    "~/Library/Caches/MacApk",
    "~/Library/Logs/macapk",
    "~/Library/Preferences/org.macapk.launcher.plist",
    "~/Library/Saved Application State/org.macapk.launcher.savedState",
  ]

  caveats <<~EOS
    Mac.apk requires macOS 26.4 or later.
  EOS
end
