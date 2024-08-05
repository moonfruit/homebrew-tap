cask "font-pinyin-step" do
  version "1.9.1"
  sha256 "3e01cba09886acdd28c707d9f185ed57f001631bbe21daa00c4cd42b1b34a4bc"

  url "https://github.com/jaywcjlove/pinyin-font/releases/download/v#{version}/pinyin-step.ttf"
  name "font-pinyin-step"
  desc "Font for Pinyin"
  homepage "https://github.com/jaywcjlove/pinyin-font"

  livecheck do
    cask "font-pinyin-regular"
  end

  font "pinyin-step.ttf"
end
