cask "macast" do
  version "0.7"
  sha256 "076500271e727f11f02eebb2731d2e6e80cf80d5f077fc1191293660312e2cfa"

  url "https://github.com/xfangfang/Macast/releases/download/v#{version}/Macast-MacOS-v#{version}.dmg"
  name "macast"
  desc "DLNA Media Renderer"
  homepage "https://github.com/xfangfang/Macast"

  livecheck do
    url :homepage
    strategy :github_latest
  end

  app "Macast.app"
end
