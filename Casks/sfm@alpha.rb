cask "sfm@alpha" do
  arch arm: "Apple", intel: "Intel"

  version "1.14.0-alpha.13"
  sha256 arm:          "7edd6c6d7e4908ab1341db61b82e533628fba2dc8327073302b9230deadfa76e",
         intel:        "1e6635ccd79a5c1c97a424a37d7aac6502dc0294baad5dff99bc6280b84d706b",
         arm64_linux:  "7edd6c6d7e4908ab1341db61b82e533628fba2dc8327073302b9230deadfa76e",
         x86_64_linux: "1e6635ccd79a5c1c97a424a37d7aac6502dc0294baad5dff99bc6280b84d706b"

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
