cask "font-pinyin-wenkai-light" do
  version "1.10.1"
  sha256 "13621eab8ac4fbc31e02ad41c7ba303aa60bbf08b3f4e4ad6337ecbd7a1329b1"

  url "https://github.com/jaywcjlove/pinyin-font/releases/download/v#{version}/pinyin-wenkai-light.ttf"
  name "font-pinyin-wenkai-light"
  desc "Font for Pinyin"
  homepage "https://github.com/jaywcjlove/pinyin-font"

  livecheck do
    cask "font-pinyin-regular"
  end

  font "pinyin-wenkai-light.ttf"
end
