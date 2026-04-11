cask "rebased" do
  version "1.0.7"
  sha256 "e0417f83d3638ce1922513be721dbcf73598b7ef383a06da43357619392cfd2f"

  url "https://github.com/DetachHead/rebased/releases/download/#{version}/ideaIC-261.22158-aarch64.dmg"
  name "rebased"
  desc "Git client of jetbrains"
  homepage "https://github.com/DetachHead/rebased"

  livecheck do
    strategy :github_latest
  end

  depends_on arch: :arm64

  app "Rebased.app"
  shimscript = "#{staged_path}/rebased.wrapper.sh"
  binary shimscript, target: "rebased"

  preflight do
    File.write shimscript, <<~EOS
      #!/bin/sh
      open -na "Rebased.app" --args "$@"
    EOS
  end

  zap trash: [
    "~/Library/Preferences/io.github.detachhead.rebased.plist",
    "~/Library/Saved Application State/io.github.detachhead.rebased.savedState",
  ]
end
