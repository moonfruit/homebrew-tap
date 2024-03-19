cask "canon-mf-ufr2-printer" do
  version "10.19.17,4,0100012234,01"
  sha256 "193b27a3a18f2bdf7102e813dd48ce8b611833102daf9c15b9d2b77bdd7f06bf"

  url "https://gdlp01.c-wss.com/gds/#{version.csv.second}/#{version.csv.third}/#{version.csv.fourth}/mac-UFRII-LIPSLX-v#{version.csv.first.no_dots}-02.dmg",
      verified: "gdlp01.c-wss.com/gds/"
  name "Canon MF UFRII/UFRII LT Printer Driver & Utilities"
  desc "Printer UFRII/UFRII LT driver & utilities for Canon imageCLASS MF printers"
  homepage "https://hk.canon/en/support"

  livecheck do
    url "https://hk.canon/en/support/get-search-result-content?id=imageRUNNER+2206N&os=macOS+14"
    regex(/Printer\s+Driver.*\sV(\d+(?:\.\d+)+)\s/)
    strategy :json do |json|
      json["data"]&.select { |item| item["title"]&.match?(regex) }
                  &.map { |item| "https://hk.canon#{item["url"]}" }
                  &.map do |page_url|
        page = Homebrew::Livecheck::Strategy.page_content(page_url)[:content]
        page.scan(/data-url="([^"]*)"/)
            &.map { |item| item&.first&.gsub("&amp;", "&") }
            &.reject(&:blank?)
            &.map do |download_url|
          headers = Homebrew::Livecheck::Strategy.page_headers(download_url)
          headers&.map { |item| item["location"] }
                 &.reject(&:blank?)
                 &.map { |item| item.match(%r{(\d+)/(\d+)/(\d+)/mac-.*-v(\d\d)(\d\d)(\d\d)}) }
                 &.map { |item| "#{item[4]}.#{item[5]}.#{item[6]},#{item[1]},#{item[2]},#{item[3]}" }
        end
      end
      &.flatten
    end
  end

  depends_on macos: ">= :el_capitan"

  pkg "UFRII_LT_LIPS_LX_Installer.pkg"

  uninstall pkgutil: [
    "jp.co.canon.CUPSMFPrinter.*",
    "jp.co.canon.CUPSPrinter.*",
  ]
end
