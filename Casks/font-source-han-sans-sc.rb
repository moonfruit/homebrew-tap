cask "font-source-han-sans-sc" do
  version "2.005R"
  sha256 "e5944ea7253878409232f1ffad464e9e93879c0207eaf2960bba327eef89ed81"

  url "https://github.com/adobe-fonts/source-han-sans/releases/download/#{version}/02_SourceHanSans-VF.zip"
  name "Source Han Sans SC"
  desc "OpenType Pan-CJK fonts"
  homepage "https://github.com/adobe-fonts/source-han-sans"

  livecheck do
    cask "font-source-han-sans-vf"
  end

  font "Variable/TTF/SourceHanSansSC-VF.ttf"
end
