cask "sfm@alpha" do
  arch arm: "Apple", intel: "Intel"

  version "1.14.0-alpha.12"
  sha256 arm:          "2cb411604ef4f77aafe5b5e5e98d4d34515fef94bda4dc2e1dfd886d16a3f4b6",
         intel:        "7b32e9a8744855c145d1cebecf79b6011536de3326b48477fad0bcb99694dd94",
         arm64_linux:  "2cb411604ef4f77aafe5b5e5e98d4d34515fef94bda4dc2e1dfd886d16a3f4b6",
         x86_64_linux: "7b32e9a8744855c145d1cebecf79b6011536de3326b48477fad0bcb99694dd94"

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
