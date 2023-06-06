cask "font-jetbrains-mono-nerd-light" do
  version "3.0.2"
  sha256 "4991258b7c97071238a7459f0d3bf81a893ae7b0c849dbc47ad52833a8db7f55"

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
