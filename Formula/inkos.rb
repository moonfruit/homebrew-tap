class Inkos < Formula
  desc "Autonomous novel writing cli ai agent"
  homepage "https://github.com/Narcooo/inkos"
  url "https://registry.npmjs.org/@actalk/inkos/-/inkos-1.8.0.tgz"
  sha256 "d97eeaff9d0b01df995f7d2c5d495ee31bd411eb2fe75330959ae22ebba94498"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "2f30bd227ea6fce6ea538b787816d0fa73747625cab09656734b6834f10cde60"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "882e9c998a7dec340e840d5b9304e43016ec436ae08c2ede06b4d0ff15ee0baf"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b5617c268f1ae183ea6dee8a0cf94953858e89e940c357015eef7ad464d5ca8c"
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
