cask "flclash" do
  arch arm: "arm64", intel: "amd64"

  version "0.9.0"
  sha256 arm:   "9e5048a53b0b7a327847fb6c6dfc95c10fc39eb21c25879196a3a27fa5b02a80",
         intel: "a35fcdd74030f15695f34c72fe54f82f58126ba09658bbfe13313acceb438440"

  url "https://github.com/chen08209/FlClash/releases/download/v#{version}/FlClash-#{version}-macos-#{arch}.dmg"
  name "FlClash"
  desc "Multi-platform proxy client based on ClashMeta"
  homepage "https://github.com/chen08209/FlClash"

  livecheck do
    url :url
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on macos: :monterey

  app "FlClash.app"

  uninstall quit: "com.follow.clash"

  zap trash: [
    "~/Library/Application Support/com.follow.clash",
    "~/Library/Caches/com.follow.clash",
    "~/Library/Preferences/com.follow.clash.plist",
    "~/Library/Saved Application State/com.follow.clash.savedState",
  ]

  caveats <<~EOS
    #{token} is not signed by an identified developer, so macOS Gatekeeper
    blocks its first launch after every install or upgrade. Either allow it in:
      System Settings → Privacy & Security → Open Anyway
    or remove the quarantine attribute:
      xattr -dr com.apple.quarantine "#{appdir}/FlClash.app"
  EOS
end
