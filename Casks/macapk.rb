cask "macapk" do
  version "1.0.2379"
  sha256 "4ab633e6559a33a281b97aa19f249f8aae8fd177275890695658a6b2ab88bad2"

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
