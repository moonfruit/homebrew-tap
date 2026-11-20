class ClaudeMem < Formula
  desc "Persistent memory compression system for Claude Code"
  homepage "https://github.com/thedotmack/claude-mem"
  url "https://registry.npmjs.org/claude-mem/-/claude-mem-16.0.1.tgz"
  sha256 "3b7509510074e7d8ae3dc50b3e374114220ee92371e3855a9aed23c4f520f2da"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256               arm64_golden_gate: "c97e196dac2e8340eabe78ac14cb6bf6a7453b6a90af07730575ad96d71602c2"
    sha256               arm64_tahoe:       "c97e196dac2e8340eabe78ac14cb6bf6a7453b6a90af07730575ad96d71602c2"
    sha256 cellar: :any, arm64_linux:       "bc4d226e09229b48a3e1d9fb963a1248b85d414fbf814f4613bef07e4fb9bdac"
    sha256 cellar: :any, x86_64_linux:      "5276e10953a61b32caa5dbd22cdbc1c4251c723e12d11203101fb3d40147b8bd"
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
