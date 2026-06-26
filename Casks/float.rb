cask "float" do
  version "1.0.10"
  sha256 "e48d92161290dfad5b14248c039563a396a20f465f63e65f302ebb8ccaa4a938"

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
