cask "font-pinyin-regular" do
  version "1.8.0"
  sha256 "1fe86bbc1ca5eb01c28f2a6ddc96c2b9a846e5deace23f64795f950389424b70"

  url "https://github.com/jaywcjlove/pinyin-font/releases/download/v#{version}/pinyin-regular.ttf"
  name "font-pinyin-regular"
  desc "Font for Pinyin"
  homepage "https://github.com/jaywcjlove/pinyin-font"

  font "pinyin-regular.ttf"
end
