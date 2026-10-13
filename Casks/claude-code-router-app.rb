cask "claude-code-router-app" do
  arch arm:   on_system_conditional(macos: "-Apple-Silicon-arm64"),
       intel: on_system_conditional(macos: "-Intel-x64")
  os macos: "-mac"
  url_end = on_system_conditional macos: "dmg", linux: "AppImage"

  version "3.1.3"
  sha256 arm:          "c0df550306051eea7f1132d4c76f7ee6b6bc7f296be7d03cfc0784e0f697fd93",
         intel:        "59daa9580d21d7037d9aaf5adaaa6a2631a18124e6eabf9046fe142020f03c6b",
         x86_64_linux: "f8a089205e5d06af96e7fab4a89c61c433fd4a56734f901bafd15abc9b852cea"

  on_macos do
    depends_on macos: :monterey

    app "Claude Code Router.app"

    zap trash: [
      "~/Library/Application Support/com.claudecoderouter.desktop",
      "~/Library/Caches/com.claudecoderouter.desktop",
      "~/Library/Logs/com.claudecoderouter.desktop",
      "~/Library/Preferences/com.claudecoderouter.desktop.plist",
      "~/Library/Saved Application State/com.claudecoderouter.desktop.savedState",
    ]
  end
  on_linux do
    depends_on arch: :x86_64

    app_image "Claude-Code-Router_#{version}#{os}#{arch}.#{url_end}", target: "Claude Code Router.AppImage"
  end

  url "https://github.com/musistudio/claude-code-router/releases/download/v#{version}/Claude-Code-Router_#{version}#{os}#{arch}.#{url_end}"
  name "Claude Code Router Desktop"
  desc "Desktop client for routing Claude Code requests across models and providers"
  homepage "https://ccrdesk.top/"

  livecheck do
    url :url
    strategy :github_latest
  end
end
