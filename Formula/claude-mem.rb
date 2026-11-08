class ClaudeMem < Formula
  desc "Persistent memory compression system for Claude Code"
  homepage "https://github.com/thedotmack/claude-mem"
  url "https://registry.npmjs.org/claude-mem/-/claude-mem-15.11.1.tgz"
  sha256 "9dd4c1b160ee5d8b564a83a7c19059b820a89e7473e77d0d99bd26cb9210de4f"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256               arm64_golden_gate: "f8897e42cc0ddadd4eb2f5da9a75b84fa7efaae2573cb3fdd838580bf6fa58bd"
    sha256               arm64_tahoe:       "f8897e42cc0ddadd4eb2f5da9a75b84fa7efaae2573cb3fdd838580bf6fa58bd"
    sha256 cellar: :any, arm64_linux:       "4f61a56558fb47ecf86e5e81ded6593b096eb0bb7ec62171db49302d280a551d"
    sha256 cellar: :any, x86_64_linux:      "a9d9de966f0e9589dfb67193cc9ed2e179d00663a43efce93ae696466e3041b9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude-mem --version")
  end
end
