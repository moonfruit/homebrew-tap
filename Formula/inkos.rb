class Inkos < Formula
  desc "Autonomous novel writing cli ai agent"
  homepage "https://github.com/Narcooo/inkos"
  url "https://registry.npmjs.org/@actalk/inkos/-/inkos-1.8.0.tgz"
  sha256 "d97eeaff9d0b01df995f7d2c5d495ee31bd411eb2fe75330959ae22ebba94498"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "45e4c4d6e4b2c94f4b16ec39db57cdadaae571087ab0711b435c13015789b428"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6cca75a363f5e1c7f161a20dcff65dc176df10069c18ca9a1717c24fa1d07454"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c7abf16ed9ba2daf888814516dd1f6d3de1b4b99999e2e0f1e29d915ffb45449"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "bab1d809953d8b3320c1a9dcdf9adbf8e6c502f05984c5d19578221ee3742145"
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
