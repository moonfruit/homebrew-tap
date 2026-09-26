cask "flclash" do
  arch arm: "arm64", intel: "amd64"

  version "0.8.98"
  sha256 arm:   "daaa8449f6b0e67ced7aa0472df2f15befbd5ed5944f36da4f90b0051a38ddb1",
         intel: "d72a5aea55e8514f742ab9567016f2e7d4c44e8c190012e291997e42c876c5e1"

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
