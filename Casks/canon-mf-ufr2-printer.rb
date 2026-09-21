cask "canon-mf-ufr2-printer" do
  version "10.19.26,09,6,0100012886,06"
  sha256 "4cfa0e3a49e74aaef49e15a3c0252eabb2b0bb4484162cbf35ce212b7724d6ca"

  url "https://gdlp01.c-wss.com/gds/#{version.csv.third}/#{version.csv.fourth}/#{version.csv.fifth}/mac-UFRII-LIPSLX-v#{version.csv.first.no_dots}-#{version.csv.second}.dmg"
  name "Canon MF UFRII/UFRII LT Printer Driver & Utilities"
  desc "Printer UFRII/UFRII LT driver & utilities for Canon imageCLASS MF printers"
  homepage "https://hk.canon/en/support"

  livecheck do
    url "https://hk.canon/hong-kong/en/support/imageRUNNER%202206__%202206N/get-search-result-content", post_form: {
      q:  "Printer Driver",
      os: "macOS 12",
    }
    regex(/href="([^"]*)"/i)
    strategy :page_match do |page, regex|
      page.scan(regex)
          &.map { |href| "https://hk.canon#{href[0]}" }
          &.reject(&:blank?)
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

  depends_on macos: :monterey

  pkg "UFRII_LT_LIPS_LX_Installer.pkg"

  uninstall pkgutil: [
    "jp.co.canon.CUPSMFPrinter.*",
    "jp.co.canon.CUPSPrinter.*",
  ]
end
