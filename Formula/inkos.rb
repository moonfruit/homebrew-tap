class Inkos < Formula
  desc "Autonomous novel writing cli ai agent"
  homepage "https://github.com/Narcooo/inkos"
  url "https://registry.npmjs.org/@actalk/inkos/-/inkos-1.6.3.tgz"
  sha256 "45660e2f50a78c525d6163f9ffebfb8102400a9c6b343ce01aed49ec10712271"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "27dc83abc138b877ba88c3433db3e8ea2ba6d32f4cb509f4aa24d42349a9672c"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "d0dee556a932893113a942ab2a80757d7590a8cf840c9467c03e70e26970dd11"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "be50ecf7e1716dab9d85787313d5292fbf6686922e55cc2d2d363d4d529aeff0"
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
