cask "font-source-han-sans" do
  version "2.004R"
  sha256 "6f59118a9adda5a7fe4e9e6bb538309f7e1d3c5411f9a9d32af32a79501b7e4f"

  url "https://github.com/adobe-fonts/source-han-sans/releases/download/#{version}/SourceHanSans.ttc.zip"
  name "Source Han Sans"
  desc "OpenType Pan-CJK fonts"
  homepage "https://github.com/adobe-fonts/source-han-sans"

  font "SourceHanSans.ttc"
end
