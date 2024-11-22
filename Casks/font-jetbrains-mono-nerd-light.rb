cask "font-jetbrains-mono-nerd-light" do
  version "3.3.0"
  sha256 "7d171ea3884be22fc08bf1a1aee640a3dc93f031989c27f6f9ceb30a6a668de1"

  url "https://github.com/ryanoasis/nerd-fonts/releases/download/v#{version}/JetBrainsMono.tar.xz"
  name "JetBrains Mono Nerd Font"
  desc "Typeface made for developers"
  homepage "https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/JetBrainsMono"

  livecheck do
    cask "font-jetbrains-mono-nerd-font"
  end

  conflicts_with cask: "font-jetbrains-mono-nerd-font"

  font "JetBrainsMonoNerdFont-Bold.ttf"
  font "JetBrainsMonoNerdFont-BoldItalic.ttf"
  font "JetBrainsMonoNerdFont-ExtraBold.ttf"
  font "JetBrainsMonoNerdFont-ExtraBoldItalic.ttf"
  font "JetBrainsMonoNerdFont-ExtraLight.ttf"
  font "JetBrainsMonoNerdFont-ExtraLightItalic.ttf"
  font "JetBrainsMonoNerdFont-Italic.ttf"
  font "JetBrainsMonoNerdFont-Light.ttf"
  font "JetBrainsMonoNerdFont-LightItalic.ttf"
  font "JetBrainsMonoNerdFont-Medium.ttf"
  font "JetBrainsMonoNerdFont-MediumItalic.ttf"
  font "JetBrainsMonoNerdFont-Regular.ttf"
  font "JetBrainsMonoNerdFont-SemiBold.ttf"
  font "JetBrainsMonoNerdFont-SemiBoldItalic.ttf"
  font "JetBrainsMonoNerdFont-Thin.ttf"
  font "JetBrainsMonoNerdFont-ThinItalic.ttf"
end
