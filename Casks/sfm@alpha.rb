cask "sfm@alpha" do
  arch arm: "Apple", intel: "Intel"

  version "1.14.0-alpha.15"
  sha256 arm:          "076e9e65ee12bf4cd44aa3e2719ad3313b9e90492e66d64b2dbde6729c85ae56",
         intel:        "2024189b7d22e95e29c64e6c89ff409d507420855d27084b09bc0d53dcd526be",
         arm64_linux:  "076e9e65ee12bf4cd44aa3e2719ad3313b9e90492e66d64b2dbde6729c85ae56",
         x86_64_linux: "2024189b7d22e95e29c64e6c89ff409d507420855d27084b09bc0d53dcd526be"

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
