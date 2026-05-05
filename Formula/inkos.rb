class Inkos < Formula
  desc "Autonomous novel writing cli ai agent"
  homepage "https://github.com/Narcooo/inkos"
  url "https://registry.npmjs.org/@actalk/inkos/-/inkos-1.3.8.tgz"
  sha256 "5c9c8a4e51e3ab3fce227d9d691e197628fa3c38e632e3acd7dec65a69022280"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "326fe3079d9a818d50e0aa18a04158ad5d6a8046cdcce29db09b915732fd8681"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "92999c896b2e4a72d2b0bad699b64754d13c5e10ea427cde2413ea8635d689a4"
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
