cask "font-jetbrains-mono-light" do
  version "2.304"
  sha256 "6f6376c6ed2960ea8a963cd7387ec9d76e3f629125bc33d1fdcd7eb7012f7bbf"

  url "https://github.com/JetBrains/JetBrainsMono/releases/download/v#{version}/JetBrainsMono-#{version}.zip",
      verified: "github.com/JetBrains/JetBrainsMono/"
  name "JetBrains Mono"
  desc "Typeface made for developers"
  homepage "https://www.jetbrains.com/lp/mono"

  livecheck do
    url "https://github.com/JetBrains/JetBrainsMono"
    strategy :gitHub_latest
  end

  conflicts_with cask: "font-jetbrains-mono"

  font "fonts/ttf/JetBrainsMono-Bold.ttf"
  font "fonts/ttf/JetBrainsMono-BoldItalic.ttf"
  font "fonts/ttf/JetBrainsMono-ExtraBold.ttf"
  font "fonts/ttf/JetBrainsMono-ExtraBoldItalic.ttf"
  font "fonts/ttf/JetBrainsMono-ExtraLight.ttf"
  font "fonts/ttf/JetBrainsMono-ExtraLightItalic.ttf"
  font "fonts/ttf/JetBrainsMono-Italic.ttf"
  font "fonts/ttf/JetBrainsMono-Light.ttf"
  font "fonts/ttf/JetBrainsMono-LightItalic.ttf"
  font "fonts/ttf/JetBrainsMono-Medium.ttf"
  font "fonts/ttf/JetBrainsMono-MediumItalic.ttf"
  font "fonts/ttf/JetBrainsMono-Regular.ttf"
  font "fonts/ttf/JetBrainsMono-Thin.ttf"
  font "fonts/ttf/JetBrainsMono-ThinItalic.ttf"
  font "fonts/variable/JetBrainsMono-Italic[wght].ttf"
  font "fonts/variable/JetBrainsMono[wght].ttf"
end
