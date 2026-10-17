cask "rebased" do
  version "1.1.21"
  sha256 "4d62f28a5abd3e7614b3b75c96e2c2f35d6f735ab3d7547680a3f64b16dd63b6"

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
