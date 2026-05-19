class Inkos < Formula
  desc "Autonomous novel writing cli ai agent"
  homepage "https://github.com/Narcooo/inkos"
  url "https://registry.npmjs.org/@actalk/inkos/-/inkos-1.4.1.tgz"
  sha256 "56bfbda25e72886169a2d0a2321af1e291170bfaba7dee3d5fd7b1515492da1a"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "b55bd2f828307cb3025da6077d02610070002fc077ffcc2303cab59c63ea8fbd"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "78422a677fc8fe5db92935ca68a8242b2abd8bbb53bfb1b134cff0c943087406"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "eb71d3c21766c8fef31b5cfe745c0a08974e6b6623ea36a711338319feb8f15c"
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
