cask "float" do
  version "1.0.9"
  sha256 "4827ae1aafa07c5e2608dec17f4eb5d792a13f8f1467dd6e289332aa155f8634"

  url "https://www.float.codes/releases/Float-#{version}.dmg"
  name "Float"
  desc "Lightweight picture-in-picture browser"
  homepage "https://www.float.codes/"

  livecheck do
    url "https://www.float.codes/releases/appcast.xml"
    strategy :sparkle, &:short_version
  end

  depends_on macos: :ventura

  app "Float.app"

  zap trash: [
    "~/Library/Caches/com.float.app",
    "~/Library/HTTPStorages/com.float.app",
    "~/Library/Preferences/com.float.app.plist",
    "~/Library/WebKit/com.float.app",
  ]
end
