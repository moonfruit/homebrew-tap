class Inkos < Formula
  desc "Autonomous novel writing cli ai agent"
  homepage "https://github.com/Narcooo/inkos"
  url "https://registry.npmjs.org/@actalk/inkos/-/inkos-1.3.5.tgz"
  sha256 "1b0ef2e0d7d97088a00ae58e85f074d530d14b80fa78283ec34be4f7af8c79f5"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "3a24625b20995879003790bd85f21ba4cf86c38d08b67666b1e706b3965b31ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "00ef2423a157b43cbbef4e027d786cb7a6e7eae74b96cb273b68e731ff1b4700"
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
