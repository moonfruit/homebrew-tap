cask "font-pinyin-wenkai" do
  version "0.240331"
  sha256 "a9bc3dffc091023ffeb627b17fec7477691df8c6df1b3fcccb3d8673975f8773"

  url "https://github.com/jeffreyxuan/toneoz-font-pinyin-wenkai/releases/download/v#{version}/ToneOZ-Pinyin-WenKai.zip"
  name "font-pinyin-wenkai"
  desc "Font for Chinese characters with Pinyin"
  homepage "https://github.com/jeffreyxuan/toneoz-font-pinyin-wenkai"

  font "ToneOZ-Pinyin-WenKai-Bold.ttf"
  font "ToneOZ-Pinyin-WenKai-Light.ttf"
  font "ToneOZ-Pinyin-WenKai-Regular.ttf"
end
