cask "flclash" do
  arch arm: "arm64", intel: "amd64"

  version "0.9.4"
  sha256 arm:   "db0784e7e5a69fc93da85accf4d8d80812e7e014f2082609da395ba6124195c5",
         intel: "481f742112572a6488a5ec40ddd071283dc59eb4d91da1e399be25acaf79e8eb"

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
