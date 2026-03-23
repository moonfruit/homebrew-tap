class SingBoxApple < Formula
  desc "Standalone client for sing-box, the universal proxy platform"
  homepage "https://sing-boxr.dustinwin.us.kg/"
  url "https://github.com/reF1nd/sing-box/archive/refs/tags/v1.14.0-alpha.3-reF1nd.tar.gz"
  version "1.14.0-alpha.3-reF1nd"
  sha256 "8d76f2e6803936860a0f99f86f866977eb4ab507f5649d3b501363ae06dcdd79"
  license "GPL-3.0-or-later"
  head "https://github.com/reF1nd/sing-box.git", branch: "reF1nd-dev-next"

  livecheck do
    formula "sing-box-ref1nd"
  end

  depends_on "go" => :build
  depends_on "xcbeautify" => :build
  depends_on xcode: :build
  depends_on :macos

  resource "apple" do
    url "https://github.com/SagerNet/sing-box-for-apple/archive/f3b4b2238efd238fb1ec6ef2da88017b60a6cfa1.tar.gz"
    sha256 "5cf76198a75dd9fad359712c33c384d9076a14e7452b384a77f82afc33181a23"
  end

  resource "runestone" do
    url "https://github.com/nekohasekai/Runestone/archive/1e126c3f316184c318c74c30803c4c098c3afbd8.tar.gz"
    sha256 "416568b10083ddfc830abad57ea46b31b77617bf1ecbf009c9cc4934845d07d3"
  end

  def install
    ENV["GOPATH"] = buildpath/"go"
    ENV.prepend_path "PATH", buildpath/"go/bin"
    system "make", "lib_install"

    system "go", "run", "./cmd/internal/build_libbox", "-target", "apple", "-platform", "macos"

    resource("apple").stage buildpath/"clients/apple"
    ln_sf buildpath/"Libbox.xcframework", buildpath/"clients/apple/Libbox.xcframework"
    resource("runestone").stage buildpath/"clients/apple/Frameworks/Runestone"

    arch = Hardware::CPU.arm? ? "apple" : "intel"
    system "make", "-C", "clients/apple", "archive_macos_standalone_#{arch}"
  end

  test do
    system "true"
  end
end
