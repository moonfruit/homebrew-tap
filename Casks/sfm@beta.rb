cask "sfm@beta" do
  arch arm: "Apple", intel: "Intel"

  version "1.15.0-alpha.14"
  sha256 arm:   "f5c426722fa6c12dbf909e1b39e96656a5c5e969c92aacadaf76fd4a512dfa4a",
         intel: "d99b1e354789be3bdca9f2f1595b2c60178b4766c5e2217c08b6a7f3b393f3cb"

  url "https://github.com/SagerNet/sing-box/releases/download/v#{version}/SFM-#{version}-#{arch}.pkg"
  name "SFM beta"
  desc "Standalone client for sing-box, the universal proxy platform"
  homepage "https://sing-box.sagernet.org/"

  livecheck do
    regex(/^v?(\d+(?:\.\d+)+(?:[._-](?:alpha|beta)[._-]?\d+)?)$/i)
  end

  depends_on macos: :ventura

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
