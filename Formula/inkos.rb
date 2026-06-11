class Inkos < Formula
  desc "Autonomous novel writing cli ai agent"
  homepage "https://github.com/Narcooo/inkos"
  url "https://registry.npmjs.org/@actalk/inkos/-/inkos-1.5.0.tgz"
  sha256 "4b4293b1a6e51bd45c2f1de8814b360502060f5ef34aef4c3d652a7634cb5aef"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "3eda2fe163be56f410a8d0b527123614d517cf7dfe8320ccd3c221e19dced35c"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "51ddf803d636faa452136df1e50b9f769c4a6632040a544101a27e037bfaffdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0c75fabbc5d8877de4eb8c114a30fcc84d18d9d9b07de8433672c931b3b56c77"
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
