cask "workbuddy" do
  arch arm: "arm64", intel: "x64"

  version "5.1.4.31089177,d0637046"
  sha256 arm:   "e6f92e460da3e711121669128616f8b295caa4ea75232ced49fe0fd15c07d276",
         intel: "dc413199530136923af223d23f8cb1828dfb6610cf4a16d36eb9f913a6f14c77"

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
