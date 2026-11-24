cask "peach" do
  arch arm: "arm64", intel: "x86_64"

  version "0.62.0"
  sha256 arm:   "9c7fd34ed00236558d83fe4a971690683309d0e273f5253ce98a29afea28b96f",
         intel: "6338073d280d06589d6b33310f16967086a590a3910ad1349e8b03d3a93ba8fc"

  url "https://github.com/peach-mitao/peach/releases/download/v#{version}/Peach-#{version}-macos-#{arch}.dmg"
  name "Peach"
  desc "Local-first video metadata scraper and media manager"
  homepage "https://github.com/peach-mitao/peach"

  depends_on macos: :sequoia

  app "Peach.app"

  caveats <<~EOS
    Peach is not notarized and macOS may report that it is damaged. If so,
    remove the quarantine attribute before opening it:
      /usr/bin/xattr -dr com.apple.quarantine "#{appdir}/Peach.app"
  EOS
end
