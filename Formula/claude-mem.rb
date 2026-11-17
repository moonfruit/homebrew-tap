class ClaudeMem < Formula
  desc "Persistent memory compression system for Claude Code"
  homepage "https://github.com/thedotmack/claude-mem"
  url "https://registry.npmjs.org/claude-mem/-/claude-mem-15.18.5.tgz"
  sha256 "4960658a18b6a4cfeb20da3240ed7e65805ec487c735fad35fc49eab9cac63cd"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256               arm64_golden_gate: "8b384d84a9e9407df7ed20794993616f77862242891401bf9795fc3d9306ea5f"
    sha256               arm64_tahoe:       "8b384d84a9e9407df7ed20794993616f77862242891401bf9795fc3d9306ea5f"
    sha256 cellar: :any, arm64_linux:       "744b22065eb44d45380de01d1d70fc2cbae1ed55154c9f78b8a3f4cfbbd10194"
    sha256 cellar: :any, x86_64_linux:      "3e634935de3b04c32992f1142fa7eca9704338924e0c3d9626555edc1acb9a70"
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
