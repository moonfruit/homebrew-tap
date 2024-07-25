cask "font-pinyin-regular" do
  version "1.7.0"
  sha256 "28d74b9920c01bc1b1397deb8e7b69157ec14f0faaf53d0584f28751a44f6319"

  url "https://github.com/jaywcjlove/pinyin-font/releases/download/v#{version}/pinyin-regular.ttf"
  name "font-pinyin-regular"
  desc "Font for Pinyin"
  homepage "https://github.com/jaywcjlove/pinyin-font"

  font "pinyin-regular.ttf"
end
