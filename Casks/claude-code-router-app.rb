cask "claude-code-router-app" do
  arch arm:   on_system_conditional(macos: "-Apple-Silicon-arm64"),
       intel: on_system_conditional(macos: "-Intel-x64")
  os macos: "-mac"
  url_end = on_system_conditional macos: "dmg", linux: "AppImage"

  version "3.1.5"
  sha256 arm:          "1b9f2072459774b33c426bcb7b707572c44f16494db489481d1d89ac1f94eb58",
         intel:        "314c7ab7f98a6cd15bab5379ae0ec3079a8df26e3282e7c04cd99f2efc395cc7",
         x86_64_linux: "275ac2927e2e8c7edaa094948a5456b1ce3e60b02405310274e06e371f245977"

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
