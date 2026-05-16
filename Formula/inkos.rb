class Inkos < Formula
  desc "Autonomous novel writing cli ai agent"
  homepage "https://github.com/Narcooo/inkos"
  url "https://registry.npmjs.org/@actalk/inkos/-/inkos-1.3.12.tgz"
  sha256 "e2858e6b20027ae5fce762bad51d230614503e7dda5c34b3f2ae495d6daac7f2"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "f558605e99023fc3b0b0d7fbd4140c2a0e66c298544dfd7817aa3a32d67fcb28"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e4c249a55c4e932159cefae43004989e13ee36ea97ee6198891a154344fa43c0"
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
