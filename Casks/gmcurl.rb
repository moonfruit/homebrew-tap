cask "gmcurl" do
  arch arm: "aarch64", intel: "x64"

  version "1.0.2"
  sha256 :no_check

  url "https://curl.gmssl.cn/down/gmcurl_macos_#{arch}"
  name "gmcurl"
  desc "CURL with TLCP support"
  homepage "https://curl.gmssl.cn/"

  binary "gmcurl_macos_#{arch}", target: "gmcurl"
end
