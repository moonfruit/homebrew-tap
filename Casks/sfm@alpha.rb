cask "sfm@alpha" do
  arch arm: "Apple", intel: "Intel"

  version "1.14.0-alpha.21"
  sha256 arm:          "acc0eb410b79e35d477f4855c84c4ae8aa995ce91fdaef7575bcf77c77f949ff",
         intel:        "539c681ea203fa731b5aafab9b255e83786a5424e96380f9c1c7c2656e95b48a",
         arm64_linux:  "acc0eb410b79e35d477f4855c84c4ae8aa995ce91fdaef7575bcf77c77f949ff",
         x86_64_linux: "539c681ea203fa731b5aafab9b255e83786a5424e96380f9c1c7c2656e95b48a"

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
