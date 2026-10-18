class ClaudeMem < Formula
  desc "Persistent memory compression system for Claude Code"
  homepage "https://github.com/thedotmack/claude-mem"
  url "https://registry.npmjs.org/claude-mem/-/claude-mem-14.0.1.tgz"
  sha256 "48fb5123bc0f9d7f5962692775b9b6293be8bba2566006d8a608cb42bf301bd8"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256                               arm64_golden_gate: "5df67d23b9a11e66fddcfa1dc3b32b7c17d47b88348cad09463870530cfdb39c"
    sha256                               arm64_tahoe:       "5df67d23b9a11e66fddcfa1dc3b32b7c17d47b88348cad09463870530cfdb39c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "833451cc9792fc9f7011fe5a2f515fabd94da7f163599a5e3b32476a0d1a1036"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "833451cc9792fc9f7011fe5a2f515fabd94da7f163599a5e3b32476a0d1a1036"
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
