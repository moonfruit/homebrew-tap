class Inkos < Formula
  desc "Autonomous novel writing cli ai agent"
  homepage "https://github.com/Narcooo/inkos"
  url "https://registry.npmjs.org/@actalk/inkos/-/inkos-1.8.0.tgz"
  sha256 "d97eeaff9d0b01df995f7d2c5d495ee31bd411eb2fe75330959ae22ebba94498"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3d442db62da685b228d492c4b4f831118360e75c704061eef32f5e59f6b59266"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3d442db62da685b228d492c4b4f831118360e75c704061eef32f5e59f6b59266"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0fdc6e1bf671d393d3cead88159fbc1c662880440f609c227a57feec7c5ca2f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "0fdc6e1bf671d393d3cead88159fbc1c662880440f609c227a57feec7c5ca2f8"
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
