class ClaudeMem < Formula
  desc "Persistent memory compression system for Claude Code"
  homepage "https://github.com/thedotmack/claude-mem"
  url "https://registry.npmjs.org/claude-mem/-/claude-mem-13.39.0.tgz"
  sha256 "5ea87d3bbc8ffc10ea2d2b790dce8d23626f6effbabfd11850f64191af6651dd"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256                               arm64_golden_gate: "e6b19acebcbad77c66b172e5c83d5b2eea660a4272c9c7603c53ed2f2169503a"
    sha256                               arm64_tahoe:       "e6b19acebcbad77c66b172e5c83d5b2eea660a4272c9c7603c53ed2f2169503a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9f38f8661aa259cd2d2fdf9a3f4b894b0755f9e5ab5f39bb549b2c666b503bca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "9f38f8661aa259cd2d2fdf9a3f4b894b0755f9e5ab5f39bb549b2c666b503bca"
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
