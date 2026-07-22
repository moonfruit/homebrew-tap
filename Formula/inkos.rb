class Inkos < Formula
  desc "Autonomous novel writing cli ai agent"
  homepage "https://github.com/Narcooo/inkos"
  url "https://registry.npmjs.org/@actalk/inkos/-/inkos-1.7.1.tgz"
  sha256 "0bf780590806d05a0088f99aae10bfd95dd0504f91168b5287adfd55e2d81bea"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "9d7e718acd5f24275f5ada03bf640bc939a0c44ced3bad387526e4950ac9b67f"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "834ddecb4d51b8d2e53c48bd56e2a97e1f067530ea9a3f8e77f572a553294776"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "cd688d705c57917179becf77efcd4461cdcf227fbc53a7ecd2cda5f5f0817fa3"
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
