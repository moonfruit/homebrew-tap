cask "monocode" do
  arch arm: "aarch64", intel: "x64"

  version "0.10.0"
  sha256 arm:   "2b8737186796bc09b7f22403d531014903d5e46cb2e7aaf47dead606bc0091a4",
         intel: "dfa07800e87458c91472f0e118cf4fdbc1707e2e141b430224d289eb3742335e"

  url "https://github.com/hardbeat920/monocode/releases/download/v#{version}/MonoCode_#{version}_#{arch}.dmg"
  name "MonoCode"
  desc "GUI for coding agents"
  homepage "https://usemono.dev/"

  auto_updates true
  depends_on :macos

  app "MonoCode.app"

  uninstall quit: "com.monocode.desktop"

  zap trash: [
    "~/.monocode-host",
    "~/Library/Application Support/com.monocode.desktop",
    "~/Library/Caches/com.monocode.desktop",
    "~/Library/Logs/com.monocode.desktop",
    "~/Library/Preferences/com.monocode.desktop.plist",
    "~/Library/Saved Application State/com.monocode.desktop.savedState",
    "~/Library/WebKit/com.monocode.desktop",
  ]
end
