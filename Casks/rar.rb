cask "rar" do
  arch arm: "arm", intel: "x64"

  version "7.23"
  sha256 arm:   "68b393c000758d477fde43c955ff7542f12f76f3f5e87cdda923152fc791bd4d",
         intel: "da1fb3c3d7748136c9b369b683d574b372cb1ed049a634a81f85d93918346d8f"

  url "https://www.rarlab.com/rar/rarmacos-#{arch}-#{version.no_dots}.tar.gz"
  name "RAR Archiver"
  desc "Archive manager for data compression and backups"
  homepage "https://www.rarlab.com/"

  livecheck do
    url "https://www.rarlab.com/download.htm"
    regex(/>\s*RAR\s+for\s+macOS.*?v?(\d+(:?\.\d+)+)\s*</i)
  end

  depends_on :macos

  binary "rar/rar"
  binary "rar/unrar"
  artifact "rar/default.sfx", target: "#{HOMEBREW_PREFIX}/lib/default.sfx"
  artifact "rar/rarfiles.lst", target: "#{HOMEBREW_PREFIX}/etc/rarfiles.lst"

  # No zap stanza required

  caveats <<~EOS
    #{token} is not signed by an identified developer, so macOS Gatekeeper
    blocks its first run after every install or upgrade. Either allow it in:
      System Settings → Privacy & Security → Allow Anyway
    or remove the quarantine attribute:
      xattr -dr com.apple.quarantine "#{staged_path}/rar"
  EOS
end
