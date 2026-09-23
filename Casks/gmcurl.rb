cask "gmcurl" do
  arch arm: "aarch64", intel: "x64"
  os macos: "macos", linux: "linux"

  version "1.0.3,7.88.1"
  sha256 :no_check

  on_macos do
    caveats <<~EOS
      #{token} is not signed by an identified developer, so macOS Gatekeeper
      blocks its first run after every install or upgrade. Either allow it in:
        System Settings → Privacy & Security → Allow Anyway
      or remove the quarantine attribute:
        xattr -d com.apple.quarantine "#{HOMEBREW_PREFIX}/bin/gmcurl"
    EOS
  end

  url "https://curl.gmssl.cn/down/gmcurl_#{os}_#{arch}"
  name "gmcurl"
  desc "CURL with TLCP support"
  homepage "https://curl.gmssl.cn/"

  binary "gmcurl_#{os}_#{arch}", target: "gmcurl"
end
