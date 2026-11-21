cask "claude-code-router-app" do
  arch arm:   on_system_conditional(macos: "-Apple-Silicon-arm64"),
       intel: on_system_conditional(macos: "-Intel-x64")
  os macos: "-mac"
  url_end = on_system_conditional macos: "dmg", linux: "AppImage"

  version "3.1.6"
  sha256 arm:          "3b777f024d06d09c9582235f8da76d9e286d9e56ee3dd6cab48af824a23aa682",
         intel:        "1de1449dae17764da4eee45161e7a20c5bf8ef37a2859a00dca5136193a8f429",
         x86_64_linux: "ca667950e51136aad98e444248150f89d1da4d5b725f5f1069aef1c0d0910e72"

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
