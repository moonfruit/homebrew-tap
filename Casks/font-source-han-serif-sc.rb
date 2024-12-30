cask "font-source-han-serif-sc" do
  version "2.003R"
  sha256 "86608d4c1162f80a2f2605a70d3f2072764609598271ee38eb24ea1eaa22dac8"

  url "https://github.com/adobe-fonts/source-han-serif/releases/download/#{version}/02_SourceHanSerif-VF.zip"
  name "Source Han Serif SC"
  desc "OpenType Pan-CJK fonts"
  homepage "https://github.com/adobe-fonts/source-han-serif"

  font "Variable/TTF/SourceHanSerifSC-VF.ttf"
end
