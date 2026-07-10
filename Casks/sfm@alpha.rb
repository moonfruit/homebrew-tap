cask "sfm@alpha" do
  arch arm: "Apple", intel: "Intel"

  version "1.14.0-alpha.42"
  sha256 arm:   "b9bb10587b7abb8e8918391cbda7bd739bd84fa77fac1e8d1177906618ca9b9b",
         intel: "c1783d4f8a0ea754884516076a660ef851d7c2737d5f9b32692f745529e0177d"

  url "https://github.com/SagerNet/sing-box/releases/download/v#{version}/SFM-#{version}-#{arch}.pkg",
      verified: "github.com/SagerNet/sing-box/"
  name "SFM alpha"
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
