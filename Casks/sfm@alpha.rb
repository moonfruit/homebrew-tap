cask "sfm@alpha" do
  arch arm: "Apple", intel: "Intel"

  on_macos do
    version "1.14.0-alpha.11"
    sha256 arm:   "428189fc9f85fa4034ded1690af6b8d372dbd5cbc459e08347e6c2d5b8893789",
           intel: "c6e1688925f7c71a273d3148fc489eed33a72ea95aad417dc6ddee721d90bfbb"
  end

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
