cask "font-pinyin-wenkai-light" do
  version "1.9.1"
  sha256 "aeed11b22cde02d481d7cb57f829eab0ec3f207c6b65e6fe48d6324300baf025"

  url "https://github.com/jaywcjlove/pinyin-font/releases/download/v#{version}/pinyin-wenkai-light.ttf"
  name "font-pinyin-wenkai-light"
  desc "Font for Pinyin"
  homepage "https://github.com/jaywcjlove/pinyin-font"

  livecheck do
    cask "font-pinyin-regular"
  end

  font "pinyin-wenkai-light.ttf"
end
