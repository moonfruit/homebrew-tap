cask "sfm@alpha" do
  arch arm: "Apple", intel: "Intel"

  version "1.14.0-alpha.17"
  sha256 arm:          "8e5c292493a7ce1061e87bdab293ab7da426330f674f0ae2b2c74ef2b1b3c7f3",
         intel:        "a5f7a2d52b68de2adb4fd96673f519a037ebdcf3247e6cc866c66cfb7ca390ee",
         arm64_linux:  "8e5c292493a7ce1061e87bdab293ab7da426330f674f0ae2b2c74ef2b1b3c7f3",
         x86_64_linux: "a5f7a2d52b68de2adb4fd96673f519a037ebdcf3247e6cc866c66cfb7ca390ee"

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
