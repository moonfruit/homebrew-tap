class Inkos < Formula
  desc "Autonomous novel writing cli ai agent"
  homepage "https://github.com/Narcooo/inkos"
  url "https://registry.npmjs.org/@actalk/inkos/-/inkos-1.5.0.tgz"
  sha256 "4b4293b1a6e51bd45c2f1de8814b360502060f5ef34aef4c3d652a7634cb5aef"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "e80e523c5a1a6ef9b0728a22b8dcd47bdae8f0c81d37c8f8a502ac5db5759c2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "0d27725f660f09652adec8e18c9554876ee2feb662814f92791b607d955a9d11"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "90147c5f410a74685ece5ce16f6de36a35ee349172aa55578199c1f1e25f6c52"
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
