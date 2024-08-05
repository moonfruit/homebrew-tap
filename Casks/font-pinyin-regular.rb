cask "font-pinyin-regular" do
  version "1.9.1"
  sha256 "b2cde1a8cd589408c3100f12f97a42f298ba476173fddfbb6e40a2aa71cec6cb"

  url "https://github.com/jaywcjlove/pinyin-font/releases/download/v#{version}/pinyin-regular.ttf"
  name "font-pinyin-regular"
  desc "Font for Pinyin"
  homepage "https://github.com/jaywcjlove/pinyin-font"

  font "pinyin-regular.ttf"
end
