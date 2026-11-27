cask "peach" do
  arch arm: "arm64", intel: "x86_64"

  version "0.63.0"
  sha256 arm:   "4e841c18b00c846f1d16702e60c54c55a7f272fcaf2d426b763f48a06686eeee",
         intel: "f913801fa8cd5e869b44c5433eddd63e17aba4e01e75961634eb339c0237d0a3"

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
