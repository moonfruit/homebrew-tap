cask "font-source-han-sans" do
  version "2.005R"
  sha256 "a024cf1759494847cd47aae4379bcb3dc530017c709f3f503ee0ed918dd92952"

  url "https://github.com/adobe-fonts/source-han-sans/releases/download/#{version}/01_SourceHanSans.ttc.zip"
  name "Source Han Sans"
  desc "OpenType Pan-CJK fonts"
  homepage "https://github.com/adobe-fonts/source-han-sans"

  livecheck do
    cask "font-source-han-sans-vf"
  end

  font "SourceHanSans.ttc"
end
