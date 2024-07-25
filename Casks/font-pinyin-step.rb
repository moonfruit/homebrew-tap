cask "font-pinyin-step" do
  version "1.7.0"
  sha256 "a91262877b102bbd4dbe4e8571b129ee1b02a216de108f7d2a6201a18982be27"

  url "https://github.com/jaywcjlove/pinyin-font/releases/download/v#{version}/pinyin-step.ttf"
  name "font-pinyin-step"
  desc "Font for Pinyin"
  homepage "https://github.com/jaywcjlove/pinyin-font"

  livecheck do
    cask "font-pinyin-regular"
  end

  font "pinyin-step.ttf"
end
