cask "font-source-han-sans-sc" do
  version "2.004R"
  sha256 "49c35b06645c8df7be3795be1b55363fa863b2fbd6f296340fdc61a37492ddc5"

  url "https://github.com/adobe-fonts/source-han-sans/releases/download/#{version}/SourceHanSans-VF.zip"
  name "Source Han Sans SC"
  desc "OpenType Pan-CJK fonts"
  homepage "https://github.com/adobe-fonts/source-han-sans"

  font "Variable/TTF/SourceHanSansSC-VF.ttf"
end
