cask "rebased" do
  arch arm: "-aarch64"

  version "1.1.20"
  sha256 arm:   "98b12c7f67511f3ec2214f31da713fb9fbb1923bbf94ce812deff5395afcf31b",
         intel: "09bad5d10e90f3da853b7968fda18c15fd44d4fbbafbb50ce27bca656eb9b9c8"

  url "https://github.com/DetachHead/rebased/releases/download/#{version}/rebased#{arch}.dmg"
  name "rebased"
  desc "Git client of jetbrains"
  homepage "https://github.com/DetachHead/rebased"

  livecheck do
    url :url
    strategy :github_latest
  end

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
