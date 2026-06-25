cask "workbuddy" do
  arch arm: "arm64", intel: "x64"

  version "5.1.6.31448847,0db69b64"
  sha256 arm:   "a979a7de652e5e6ad87a43b3e2b7040e087c5ddf0b23658f97c2407e60f9b1c9",
         intel: "d9f54bcef063454cffd82dc93f06fe4eab7e495333d628490befeb825af7ca48"

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
