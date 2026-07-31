class Inkos < Formula
  desc "Autonomous novel writing cli ai agent"
  homepage "https://github.com/Narcooo/inkos"
  url "https://registry.npmjs.org/@actalk/inkos/-/inkos-1.7.2.tgz"
  sha256 "600fbb89948e32d90c46758227b2d5aab39b8c64edd5cfa425578e36b85621e2"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "0b7d9b4929c20a59f4537a4387c2ecb467f952be567f5d4941de82e607b056ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "82a5bc847257603ef319b5f6636f275e0af84bd6e41b0c70454f1b5fadabcbbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7e6ef94e8637dd2edf3f113c938fb3566931a9e1471acdd96c80d63985ff7b5b"
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
