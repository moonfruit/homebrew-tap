cask "font-pinyin-step" do
  version "1.10.1"
  sha256 "45843adb0232eb2f6c0ab712847ec8b3c7ad893a59a110a1907589bba1f02e69"

  url "https://github.com/jaywcjlove/pinyin-font/releases/download/v#{version}/pinyin-step.ttf"
  name "font-pinyin-step"
  desc "Font for Pinyin"
  homepage "https://github.com/jaywcjlove/pinyin-font"

  livecheck do
    cask "font-pinyin-regular"
  end

  font "pinyin-step.ttf"
end
