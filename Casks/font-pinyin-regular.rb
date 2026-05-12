cask "font-pinyin-regular" do
  version "1.10.2"
  sha256 "03fce50e8b3143e9d71163e2b5101c1541cb63339c8b74739865a7600ca5349d"

  url "https://github.com/jaywcjlove/pinyin-font/releases/download/v#{version}/pinyin-regular.ttf"
  name "font-pinyin-regular"
  desc "Font for Pinyin"
  homepage "https://github.com/jaywcjlove/pinyin-font"

  font "pinyin-regular.ttf"
end
