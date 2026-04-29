cask "sfm@alpha" do
  arch arm: "Apple", intel: "Intel"

  version "1.14.0-alpha.20"
  sha256 arm:          "df987fcf53a80183174c3c013e28ca776f60c1cd805e7f2d0e32e681086764c4",
         intel:        "f8b01e3e2180b940abd68cfe36762746d5bfdb8dd5963d60ea0333a8372ccaf6",
         arm64_linux:  "df987fcf53a80183174c3c013e28ca776f60c1cd805e7f2d0e32e681086764c4",
         x86_64_linux: "f8b01e3e2180b940abd68cfe36762746d5bfdb8dd5963d60ea0333a8372ccaf6"

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
