cask "font-jetbrains-mono-nerd-light" do
  version "2.2.2"
  sha256 "8b9b6c58081d179ecd50839a6b211dbd24b61e66d87715860129b6138982ee7b"

  url "https://github.com/ryanoasis/nerd-fonts/releases/download/v#{version}/JetBrainsMono.zip"
  name "JetBrains Mono Nerd Font"
  desc "Typeface made for developers"
  homepage "https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/JetBrainsMono"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  conflicts_with cask: "font-jetbrains-mono-nerd-font"

  font "JetBrains Mono Bold Italic Nerd Font Complete.ttf"
  font "JetBrains Mono Bold Nerd Font Complete.ttf"
  font "JetBrains Mono ExtraBold Italic Nerd Font Complete.ttf"
  font "JetBrains Mono ExtraBold Nerd Font Complete.ttf"
  font "JetBrains Mono ExtraLight Italic Nerd Font Complete.ttf"
  font "JetBrains Mono ExtraLight Nerd Font Complete.ttf"
  font "JetBrains Mono Italic Nerd Font Complete.ttf"
  font "JetBrains Mono Light Italic Nerd Font Complete.ttf"
  font "JetBrains Mono Light Nerd Font Complete.ttf"
  font "JetBrains Mono Medium Italic Nerd Font Complete.ttf"
  font "JetBrains Mono Medium Nerd Font Complete.ttf"
  font "JetBrains Mono Regular Nerd Font Complete.ttf"
  font "JetBrains Mono SemiBold Italic Nerd Font Complete.ttf"
  font "JetBrains Mono SemiBold Nerd Font Complete.ttf"
  font "JetBrains Mono Thin Italic Nerd Font Complete.ttf"
  font "JetBrains Mono Thin Nerd Font Complete.ttf"
end
