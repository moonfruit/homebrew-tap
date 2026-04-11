cask "gmcurl" do
  arch arm: "aarch64", intel: "x64"
  os macos: "macos", linux: "linux"

  version "1.0.3,7.88.1"
  sha256 :no_check

  url "https://curl.gmssl.cn/down/gmcurl_#{os}_#{arch}"
  name "gmcurl"
  desc "CURL with TLCP support"
  homepage "https://curl.gmssl.cn/"

  binary "gmcurl_#{os}_#{arch}", target: "gmcurl"
end
