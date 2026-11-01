cask "peach" do
  arch arm: "arm64", intel: "x86_64"

  version "0.52.0"
  sha256 arm:   "971bb86027e83f2950cec2fd6fad28ac67c1df1c939305025a0969ac8024874d",
         intel: "6638460f4fcb9bd81f5c37b21367c4fcfe2e60db73bb6dfbe3d2880736e35acb"

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
