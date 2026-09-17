class Inkos < Formula
  desc "Autonomous novel writing cli ai agent"
  homepage "https://github.com/Narcooo/inkos"
  url "https://registry.npmjs.org/@actalk/inkos/-/inkos-1.8.0.tgz"
  sha256 "d97eeaff9d0b01df995f7d2c5d495ee31bd411eb2fe75330959ae22ebba94498"
  license "AGPL-3.0-only"

  bottle do
    rebuild 1
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/inkos --version")
  end
end
