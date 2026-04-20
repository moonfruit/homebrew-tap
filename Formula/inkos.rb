class Inkos < Formula
  desc "Autonomous novel writing cli ai agent"
  homepage "https://github.com/Narcooo/inkos"
  url "https://registry.npmjs.org/@actalk/inkos/-/inkos-1.3.5.tgz"
  sha256 "1b0ef2e0d7d97088a00ae58e85f074d530d14b80fa78283ec34be4f7af8c79f5"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "507e558114035a3aa5ac10e5a6ff5ae2a3940d332d3f8fedb28c19ff51882644"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3882a9acc73f18bb319586dc338f216cc74d1b81ff892ab7a1c70a2fa3eae2b1"
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
