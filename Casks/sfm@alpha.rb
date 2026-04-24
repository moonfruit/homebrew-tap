cask "sfm@alpha" do
  arch arm: "Apple", intel: "Intel"

  version "1.14.0-alpha.18"
  sha256 arm:          "669e61ff3f9d924d229bb8a5da24fabc748bcfca6252b47e5b5d27e838f1875b",
         intel:        "d463e99de81943ceffefd842a6abc9443cc1943640dd70509d0cfd01e13de998",
         arm64_linux:  "669e61ff3f9d924d229bb8a5da24fabc748bcfca6252b47e5b5d27e838f1875b",
         x86_64_linux: "d463e99de81943ceffefd842a6abc9443cc1943640dd70509d0cfd01e13de998"

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
