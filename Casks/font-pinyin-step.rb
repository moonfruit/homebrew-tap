cask "font-pinyin-step" do
  version "1.8.0"
  sha256 "7e353f48d53374fee562c9d863a2bb276ef2299bdb4da9a421431e32376140bd"

  url "https://github.com/jaywcjlove/pinyin-font/releases/download/v#{version}/pinyin-step.ttf"
  name "font-pinyin-step"
  desc "Font for Pinyin"
  homepage "https://github.com/jaywcjlove/pinyin-font"

  livecheck do
    cask "font-pinyin-regular"
  end

  font "pinyin-step.ttf"
end
