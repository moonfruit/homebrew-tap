cask "peach" do
  arch arm: "arm64", intel: "x86_64"

  version "0.61.0"
  sha256 arm:   "dc920b2f537753e4d23f7437891beddc0be9008bfadc3e73eb9278fca8e9232c",
         intel: "5d18504c4d50c0eee6009027c6f17a8b5a6479e77cbdf6339412e0d57147d409"

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
