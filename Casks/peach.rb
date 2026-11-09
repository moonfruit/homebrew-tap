cask "peach" do
  arch arm: "arm64", intel: "x86_64"

  version "0.57.0"
  sha256 arm:   "b0ed4d88de5fac134f063234ef13ec178cfc64c323c575f10aa068dc1c104e61",
         intel: "a3164143b261b75627c94aa83b64a9be1ed7479d60992b6a42aa33251a3bf659"

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
