cask "gmcurl" do
  arch arm: "arm", intel: "x64"

  version "1.0.1"
  sha256 arm:   "307972f9b27b0b730991c732b478c644bff775780ce222eaa91988f565c77676",
         intel: "d727694761438de933c02dbbfc4699ae73d0a1d9270354ac8e3cc8ab96293051"

  url "https://www.gmssl.cn/gmssl/down/gmcurl_macos_#{arch}"
  name "gmcurl"
  desc "CURL with TLCP support"
  homepage "https://www.gmssl.cn/"

  binary "gmcurl_macos_#{arch}", target: "gmcurl"
end
