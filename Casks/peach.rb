cask "peach" do
  arch arm: "arm64", intel: "x86_64"

  version "0.60.0"
  sha256 arm:   "1a00729de8a67b6743b8706975a6c63b74e5915eadb538aee33b332771aee77f",
         intel: "64f6f8e1a866c89aa1bd57f721097fe0b5a813ab66917c6ea87b20253f4edeab"

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
