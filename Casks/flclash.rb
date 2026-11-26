cask "flclash" do
  arch arm: "arm64", intel: "amd64"

  version "0.9.5"
  sha256 arm:   "0a350209c2a1ef8d181a3d0dd563ae8f86aece161f5a4e8554683caf5020bd82",
         intel: "69d68de2c4da721e554d03f9529521afb4b75334d87306be8906416e6af6fab8"

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
