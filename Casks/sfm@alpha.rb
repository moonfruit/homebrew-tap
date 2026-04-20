cask "sfm@alpha" do
  arch arm: "Apple", intel: "Intel"

  version "1.14.0-alpha.14"
  sha256 arm:          "b3105bfdb43b4916360b14ee5d5de67e1706063f0c7a748fe7e190a345371c4e",
         intel:        "b3280b7fcadea152af92293da7e72a74c6cc5ff437adc0bb67a82f7f930ae2ee",
         arm64_linux:  "b3105bfdb43b4916360b14ee5d5de67e1706063f0c7a748fe7e190a345371c4e",
         x86_64_linux: "b3280b7fcadea152af92293da7e72a74c6cc5ff437adc0bb67a82f7f930ae2ee"

  url "https://github.com/SagerNet/sing-box/releases/download/v#{version}/SFM-#{version}-#{arch}.pkg",
      verified: "github.com/SagerNet/sing-box/"
  name "SFM alpha"
  desc "Standalone client for sing-box, the universal proxy platform"
  homepage "https://sing-box.sagernet.org/"

  livecheck do
    regex(/^v?(\d+(?:\.\d+)+(?:[._-](?:alpha|beta)[._-]?\d+)?)$/i)
  end

  depends_on macos: ">= :ventura"

  pkg "SFM-#{version}-#{arch}.pkg"

  uninstall quit:       "io.nekohasekai.sfavt.standalone",
            login_item: "SFM",
            pkgutil:    "io.nekohasekai.sfavt.standalone"

  zap trash: [
    "~/Library/Application Scripts/287TTNZF8L.io.nekohasekai.sfavt",
    "~/Library/Group Containers/287TTNZF8L.io.nekohasekai.sfavt",
    "~/Library/Preferences/io.nekohasekai.sfavt.standalone.plist",
  ]
end
