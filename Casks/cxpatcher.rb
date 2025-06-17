cask "cxpatcher" do
  version "0.6.4"
  sha256 "4e2d7483f90e5186387b8e4882dc7ccdc4d209c73d9b66e20381f356d48e2727"

  url "https://github.com/italomandara/CXPatcher/releases/download/v#{version}/CXPatcher.app.zip"
  name "CXPatcher"
  desc "Patcher to upgrade CrossOver dependencies and improve compatibility"
  homepage "https://github.com/italomandara/CXPatcher"

  livecheck do
    strategy :github_latest
  end

  depends_on cask: "gstreamer-runtime"

  app "CXPatcher.app"

  zap trash: "~/Library/Preferences/com.italomandara.Crossover-patcher.plist"
end
