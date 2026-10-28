cask "katrain" do
  arch arm: "arm64", intel: "x86_64"

  version "1.20.0"
  sha256 arm:   "9f6c6f04e4b2ae526b2107e6b25d070c270099005eb89dde7d9b94d4c83fd0e6",
         intel: "f48041480ca37c1d492cd4c38e342a8d3e9299880d8a26d8ff689df631e9b301"

  url "https://github.com/sanderland/katrain/releases/download/v#{version}/KaTrain-#{version}-#{arch}.dmg"
  name "KaTrain"
  desc "Tool for analyzing games and playing go with AI feedback from KataGo"
  homepage "https://github.com/sanderland/katrain"

  depends_on :macos

  app "KaTrain.app"

  zap trash: "~/.katrain"
end
