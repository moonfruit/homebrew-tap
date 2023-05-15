cask "font-jetbrains-mono-nerd-light" do
  version "3.0.1"
  sha256 "977f16dcb70c45b8ddb5c00ca1276352ff6bfd0e5054c8628ea36f62712ecdf9"

  url "https://github.com/ryanoasis/nerd-fonts/releases/download/v#{version}/JetBrainsMono.zip"
  name "JetBrains Mono Nerd Font"
  desc "Typeface made for developers"
  homepage "https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/JetBrainsMono"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
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
