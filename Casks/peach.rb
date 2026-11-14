cask "peach" do
  arch arm: "arm64", intel: "x86_64"

  version "0.58.0"
  sha256 arm:   "8905df451f5895607fdca9bebc012bb5f9248a524aee9f81894ca9308f5a8f1e",
         intel: "ae02b0c5797766fdcb3850f1d500dbd01a528da317ce3005fe4851fad8a87ba7"

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
