cask "gmcurl" do
  arch arm: "aarch64", intel: "x64"
  os macos: "macos", linux: "linux"

  version "1.0.3"
  sha256 arm:          "845bee162a2b8205cd87c6fcac17955a3b4bfc305108e9e644771740e9e42757",
         intel:        "a95b6d5e704a90f5b5dc3461fef1d6d677cba86e63997ff4acfcc15c34a89618",
         arm64_linux:  "4d307ea153862963868d9408c1a1bfef1363432c14d2b877c069491595598d38",
         x86_64_linux: "69c6ef0d5e8788b92e9c3c90b2faa6d680a645151bb1c1acaee5302d799217ba"

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

  livecheck do
    url "https://curl.gmssl.cn/txt/version.txt"
    regex(/^V(\d+(?:\.\d+)+)/i)
  end

  binary "gmcurl_#{os}_#{arch}", target: "gmcurl"
end
