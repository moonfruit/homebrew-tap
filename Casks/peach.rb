cask "peach" do
  arch arm: "arm64", intel: "x86_64"

  version "0.54.0"
  sha256 arm:   "47bd9ab18c764a4f68e34934a5f878c942820ee0322369b784fae8e3aea4328a",
         intel: "12c849dd3600b29af99cac4a7788ae27dc9b35f33be5cad7f3350737cffc3189"

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
