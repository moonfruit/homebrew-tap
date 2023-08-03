cask "canon-mf-ufr2-printer" do
  version "10.19.15"
  sha256 "042821d27cddff8d35489be405be6fb6758a74e2357dcf8b86a6decc26d7aaef"

  url "https://gdlp01.c-wss.com/gds/8/0100011758/05/mac-UFRII-LIPSLX-v#{version.no_dots}-02.dmg",
      verified: "gdlp01.c-wss.com/gds/"
  name "Canon MF UFRII/UFRII LT Printer Driver & Utilities"
  desc "Printer UFRII/UFRII LT driver & utilities for Canon imageCLASS MF printers"
  homepage "https://hk.canon/en/support"

  livecheck do
    url "https://hk.canon/en/support/get-search-result-content?id=imageRUNNER+2206N&os=macOS+13"
    regex(/Printer\s+Driver.*\sV(\d+(?:\.\d+)+)\s/)
    strategy :json do |json|
      json["data"].select { |item| item["title"]&.match?(regex) }
                  .map { |item| item["title"][regex, 1] }
    end
  end

  depends_on macos: ">= :el_capitan"

  pkg "UFRII_LT_LIPS_LX_Installer.pkg"

  uninstall pkgutil: [
    "jp.co.canon.CUPSMFPrinter.*",
    "jp.co.canon.CUPSPrinter.*",
  ]
end
