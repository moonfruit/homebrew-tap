cask "peach" do
  arch arm: "arm64", intel: "x86_64"

  version "0.56.0"
  sha256 arm:   "3292625690d5a6348a789f41341e436e5078c087f13d32636f6c37adfcc8b983",
         intel: "00b07be53762d7c8962728fbea93af332c078d939890a004fc353081a598fe0e"

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
