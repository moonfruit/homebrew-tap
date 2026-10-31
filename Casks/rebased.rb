cask "rebased" do
  version "1.1.23"
  sha256 "0ce819fac25412c642e8d57fabd712890684d55518a1c54a1cfd9d4976922cf2"

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
