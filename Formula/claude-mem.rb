class ClaudeMem < Formula
  desc "Persistent memory compression system for Claude Code"
  homepage "https://github.com/thedotmack/claude-mem"
  url "https://registry.npmjs.org/claude-mem/-/claude-mem-15.12.0.tgz"
  sha256 "78ec517c9a4203e063a8ccc1c9cd3c6b3efef40bc14c4074600107b00e8d76af"
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
