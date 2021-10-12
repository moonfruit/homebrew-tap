cask "macast" do
  version "0.65"
  sha256 "495e9cc012ecf2a40ff9b44620b3ad27a16845eecc186f13e2a851ce40c163c7"

  url "https://github.com/xfangfang/Macast/releases/download/v#{version}/Macast-MacOS-v#{version}.dmg"
  name "macast"
  desc "https://github.com/xfangfang/Macast"
  homepage "DLNA Media Renderer"

  app "Macast.app"
end
