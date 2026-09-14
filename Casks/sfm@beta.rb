cask "sfm@beta" do
  arch arm: "Apple", intel: "Intel"

  version "1.15.0-alpha.3"
  sha256 arm:   "cc7429a1a9d208cdafe37dfc38d4ea66f94d1ae16d9fcd2ccf28eb98b80453b1",
         intel: "b908da8eba63d0156fbe3df0117cd75d7ab07843d16a0da6cb3200b4f9179d09"

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
