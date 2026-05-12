cask "font-pinyin-wenkai-light" do
  version "1.10.2"
  sha256 "0b89833a9339f11dde277aa0ba25449e4d097149e01987d85763fd237ee4eb77"

  url "https://github.com/jaywcjlove/pinyin-font/releases/download/v#{version}/pinyin-wenkai-light.ttf"
  name "font-pinyin-wenkai-light"
  desc "Font for Pinyin"
  homepage "https://github.com/jaywcjlove/pinyin-font"

  livecheck do
    cask "font-pinyin-regular"
  end

  font "pinyin-wenkai-light.ttf"
end
