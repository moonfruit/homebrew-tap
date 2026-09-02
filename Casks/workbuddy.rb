cask "workbuddy" do
  arch arm: "arm64", intel: "x64"

  version "5.5.1.37570276,9af62480"
  sha256 arm:   "d070b13f96dbea376820e165e4674be04801ca775dfe1c30933ab6d92f46295c",
         intel: "611b576446bb77f0364e0d385e86f142ced2e054b2d507fcc7cf9fb20dec873e"

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
