cask "workbuddy" do
  arch arm: "arm64", intel: "x64"

  version "5.1.5.31270648,a1798eab"
  sha256 arm:   "463a12d7092425368d0b70e479e4ecfca24a72e792f9588eddfd40559713db27",
         intel: "93477e841b4dad13637371a6188a63b5b2fe41d60dee12f785153a0fe33f4b59"

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
