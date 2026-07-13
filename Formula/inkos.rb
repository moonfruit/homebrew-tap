class Inkos < Formula
  desc "Autonomous novel writing cli ai agent"
  homepage "https://github.com/Narcooo/inkos"
  url "https://registry.npmjs.org/@actalk/inkos/-/inkos-1.7.0.tgz"
  sha256 "970be5e368286f7dec78e69eb3ea8b3760141f93af2d09640ed01ea43ce48cb7"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "606fdf007ca61f83a2cc994a76365903d4458f52aa249bc2625ccf3a8fda57f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "a1df5480e3b9ca73827292c6f8af71f3c51dfef8db9168f8c2bae6fd62741876"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "24e7630a51c8f2334dc7772f181c65a9d650cfec6e407432de910928d0b32f93"
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
