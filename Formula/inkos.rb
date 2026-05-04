class Inkos < Formula
  desc "Autonomous novel writing cli ai agent"
  homepage "https://github.com/Narcooo/inkos"
  url "https://registry.npmjs.org/@actalk/inkos/-/inkos-1.3.7.tgz"
  sha256 "7535f82442a64919fc011510877aede0b499e22e1249192d473ed9ae280fb934"
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
