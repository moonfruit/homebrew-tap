cask "rebased" do
  version "1.1.24"
  sha256 "ea07252eb43052c77caf1dae5431c30ddf8e838fe8091a806a0e3747905e0e5a"

  url "https://github.com/DetachHead/rebased/releases/download/#{version}/rebased-aarch64.dmg"
  name "rebased"
  desc "Git client of jetbrains"
  homepage "https://github.com/DetachHead/rebased"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on :macos

  app "Rebased.app"
  command_wrapper "rebased", content: <<~EOS
    #!/bin/sh
    open -na "Rebased.app" --args "$@"
  EOS

  zap trash: [
    "~/Library/Preferences/io.github.detachhead.rebased.plist",
    "~/Library/Saved Application State/io.github.detachhead.rebased.savedState",
  ]

  caveats <<~EOS
    #{token} has an invalid code signature, so macOS Gatekeeper reports it as
    damaged after every install or upgrade. Remove the quarantine attribute:
      xattr -dr com.apple.quarantine "#{appdir}/Rebased.app"
  EOS
end
