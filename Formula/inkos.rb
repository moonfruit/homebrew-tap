class Inkos < Formula
  desc "Autonomous novel writing cli ai agent"
  homepage "https://github.com/Narcooo/inkos"
  url "https://registry.npmjs.org/@actalk/inkos/-/inkos-1.6.1.tgz"
  sha256 "634cdb71e92f9aeea6dc3e59e066c13d1058f1cbf1cc7a6b735ba3a264be4bde"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "5651e61a91d6942dbc4180cf3a69e6069b8fca432e2be73b70c1f2f0dd924ae3"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "9f84712bf5896b6d638cc631fbee87c732f3a1fccb7349b31ac3ddb0348cead1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "aa33dc6002c8339019789e5bc08f401f66a0244c403d5b545ff66b06a489de9d"
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
