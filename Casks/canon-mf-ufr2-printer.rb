cask "canon-mf-ufr2-printer" do
  version "10.19.14,08,8,0100011758,02"
  sha256 "19fef4c102974e9fb43def2ed60d4d853a5696855ded7f9c952a52e2bd25db34"

  url "https://gdlp01.c-wss.com/gds/#{version.csv.third}/#{version.csv.fourth}/#{version.csv.fifth}/mac-UFRII-LIPSLX-v#{version.csv.first.no_dots}-#{version.csv.second}.dmg",
      verified: "gdlp01.c-wss.com/gds/"
  name "Canon MF UFRII/UFRII LT Printer Driver & Utilities"
  desc "Printer UFRII/UFRII LT driver & utilities for Canon imageCLASS MF printers"
  homepage "https://www.usa.canon.com/internet/portal/us/home/support/drivers-downloads"

  livecheck do
    skip "No version information available"
  end

  depends_on macos: ">= :el_capitan"

  pkg "UFRII_LT_LIPS_LX_Installer.pkg"

  uninstall pkgutil: [
    "jp.co.canon.CUPSMFPrinter.*",
    "jp.co.canon.CUPSPrinter.*",
  ]
end
