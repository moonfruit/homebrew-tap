cask "font-jetbrains-mono-nerd-light" do
  version "2.3.3"
  sha256 "187c316bb77ed1c824099fe8621a17d14f7de8a6ce5b14a1a04de0ae674b4aa6"

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
