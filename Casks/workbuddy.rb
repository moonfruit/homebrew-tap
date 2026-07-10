cask "workbuddy" do
  arch arm: "arm64", intel: "x64"

  version "5.2.5.32793105,1067a2de"
  sha256 arm:   "b73ea1ff37ec5281f7625447e84e4d83ef7fbee4fd51f479742f963aa9d0b145",
         intel: "a5bdcebf50c3b41792658fc904a4d8670a56048e95fd7967aa9cead013921a9d"

  url "https://download.codebuddy.cn/workbuddy/saas/darwin-#{arch}/WorkBuddy-darwin-#{arch}-#{version.csv.first}-#{version.csv.second}.dmg"
  name "WorkBuddy"
  desc "AI agent workspace for office work"
  homepage "https://www.codebuddy.cn/work/"

  livecheck do
    url "https://www.codebuddy.cn/v2/update?platform=workbuddy-darwin-arm64"
    regex(/-(\h+)\.(?:zip|dmg)$/i)
    strategy :json do |json, regex|
      next if json["version"].blank?

      match = json["url"].to_s.match(regex)
      next json["version"] if match.blank?

      "#{json["version"]},#{match[1]}"
    end
  end

  auto_updates true
  depends_on macos: :big_sur

  app "WorkBuddy.app"

  zap trash: [
    "~/Library/Application Support/WorkBuddy",
    "~/Library/Caches/com.workbuddy.workbuddy",
    "~/Library/Caches/com.workbuddy.workbuddy.ShipIt",
    "~/Library/Logs/WorkBuddy",
    "~/Library/Preferences/com.workbuddy.workbuddy.plist",
    "~/Library/Saved Application State/com.workbuddy.workbuddy.savedState",
  ]
end
