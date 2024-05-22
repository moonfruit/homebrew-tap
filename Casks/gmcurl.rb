cask "gmcurl" do
  arch arm: "aarch64", intel: "x64"

  version "1.0.2"
  sha256 arm:   "f1d45abad41ad792d371d73a8f16f9a60e5ce3af6c91b73fd73cec8eb3d9c3fd",
         intel: "aeaf7aa7e01157ec890f9b96b7e7c9aac468396e6517a1e83e2ad6171ef03ba2"

  url "https://curl.gmssl.cn/down/gmcurl_macos_#{arch}"
  name "gmcurl"
  desc "CURL with TLCP support"
  homepage "https://curl.gmssl.cn/"

  binary "gmcurl_macos_#{arch}", target: "gmcurl"
end
