cask "peach" do
  arch arm: "arm64", intel: "x86_64"

  version "0.53.0"
  sha256 arm:   "649d39a262c92a2885e97878387039e99b778f780317a84af7c6611d80a8d5b6",
         intel: "1b4260f2544a21e03a107694b5e9cfd359765aba49cdafdfbe09577cc4ee9cb5"

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
