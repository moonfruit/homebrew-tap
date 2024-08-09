cask "font-pinyin-regular" do
  version "1.10.1"
  sha256 "2d308f3ebd984281f39e894fdc91924da9102ebc0a1540e056edca43d4e5bd55"

  url "https://github.com/jaywcjlove/pinyin-font/releases/download/v#{version}/pinyin-regular.ttf"
  name "font-pinyin-regular"
  desc "Font for Pinyin"
  homepage "https://github.com/jaywcjlove/pinyin-font"

  font "pinyin-regular.ttf"
end
