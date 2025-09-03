cask "canon-mf-ufr2-printer" do
  version "10.19.22,01,5,0100012485,03"
  sha256 "04d7b71fb17cda76227df8c5e8d4bc2828533f4e96c8799ead79f4e8485ce105"

  url "https://gdlp01.c-wss.com/gds/#{version.csv.third}/#{version.csv.fourth}/#{version.csv.fifth}/mac-UFRII-LIPSLX-v#{version.csv.first.no_dots}-#{version.csv.second}.dmg",
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
                 &.map { |item| item.match(%r{(\d+)/(\d+)/(\d+)/mac-.*-v(\d\d)(\d\d)(\d\d)-(\d+)}) }
                 &.map { |item| "#{item[4]}.#{item[5]}.#{item[6]},#{item[7]},#{item[1]},#{item[2]},#{item[3]}" }
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
