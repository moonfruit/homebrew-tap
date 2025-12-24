cask "meshmixer" do
  version "3.5.474"
  sha256 :no_check

  url "https://web.archive.org/web/20190731155031/http://www.meshmixer.com/downloads/Autodesk_Meshmixer_v3p5_MacOS.pkg",
      verified: "web.archive.org/"
  name "meshmixer"
  desc "3D modeling software"
  homepage "https://meshmixer.org/"

  pkg "Autodesk_Meshmixer_v3p5_MacOS.pkg"

  uninstall pkgutil: "com.meshmixer.*"

  zap trash: "~/Documents/meshmixer"
end
