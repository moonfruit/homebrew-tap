cask "font-pinyin-step" do
  version "1.10.2"
  sha256 "9931a418597adb746c6c49b635e91f296d360075835baf39c849ee10d844eedc"

  url "https://github.com/jaywcjlove/pinyin-font/releases/download/v#{version}/pinyin-step.ttf"
  name "font-pinyin-step"
  desc "Font for Pinyin"
  homepage "https://github.com/jaywcjlove/pinyin-font"

  livecheck do
    cask "font-pinyin-regular"
  end

  font "pinyin-step.ttf"
end
