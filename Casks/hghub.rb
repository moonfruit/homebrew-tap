cask "hghub" do
  version "1.2.0"
  sha256 "19e63c84db33dd628b2a71bcaceba48d7dfaedae17f4740e1d995a738ba4be9b"

  url "https://github.com/Minireel/HGhub/releases/download/v#{version}/HGhub_#{version}_universal.dmg"
  name "HGhub"
  desc "Third-party YellowFruit short drama client"
  homepage "https://github.com/Minireel/HGhub"

  livecheck do
    url :url
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on :macos

  app "HGhub.app"

  uninstall quit: "com.hghub.huangguo"

  zap trash: [
    "~/Library/Application Support/com.hghub.huangguo",
    "~/Library/Caches/com.hghub.huangguo",
    "~/Library/Preferences/com.hghub.huangguo.plist",
    "~/Library/Saved Application State/com.hghub.huangguo.savedState",
    "~/Library/WebKit/com.hghub.huangguo",
  ]

  caveats <<~EOS
    #{token} is not signed by an identified developer, so macOS Gatekeeper
    may block its first launch after every install or upgrade. Allow it in:
      System Settings → Privacy & Security → Open Anyway
  EOS
end
