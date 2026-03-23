class Libbox < Formula
  desc "Framework for sing-box, the universal proxy platform"
  homepage "https://sing-boxr.dustinwin.us.kg/"
  url "https://github.com/reF1nd/sing-box/archive/refs/tags/v1.14.0-alpha.3-reF1nd.tar.gz"
  version "1.14.0-alpha.3-reF1nd"
  sha256 "8d76f2e6803936860a0f99f86f866977eb4ab507f5649d3b501363ae06dcdd79"
  license "GPL-3.0-or-later"
  head "https://github.com/reF1nd/sing-box.git", branch: "reF1nd-testing"

  livecheck do
    formula "sing-box-ref1nd"
  end

  depends_on "go" => :build
  depends_on xcode: :build
  depends_on :macos

  def install
    ENV["GOPATH"] = buildpath
    ENV.prepend_path "PATH", buildpath/"bin"
    system "make", "lib_install"

    system "go", "run", "./cmd/internal/build_libbox", "-target", "apple", "-platform", "macos"
    frameworks.install "Libbox.xcframework"
  end

  test do
    system "true"
  end
end
