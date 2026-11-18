cask "peach" do
  arch arm: "arm64", intel: "x86_64"

  version "0.59.0"
  sha256 arm:   "39b5fd47a163c1408742f55922ba87bd9f3ede837d7d93c135359dc66936c479",
         intel: "7546aab6be64f994a8ae442beef3276ef9de6ae68ec972064267d13a4b34ab4b"

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
