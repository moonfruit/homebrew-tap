class ClaudeMem < Formula
  desc "Persistent memory compression system for Claude Code"
  homepage "https://github.com/thedotmack/claude-mem"
  url "https://registry.npmjs.org/claude-mem/-/claude-mem-15.21.0.tgz"
  sha256 "898b808979a950ce27dd2e9e4fb7115a87422c3b468e094b95871d511710f151"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256               arm64_golden_gate: "45ba007a5439ecfd1ad04453d8751722bcc08dc90d35cc668bb45fb33e20fdc2"
    sha256               arm64_tahoe:       "45ba007a5439ecfd1ad04453d8751722bcc08dc90d35cc668bb45fb33e20fdc2"
    sha256 cellar: :any, arm64_linux:       "acbfee63e97b6ef2f0bad51ec7f59cbd77be2d8b741dbb82c5afb7f54b32bd0e"
    sha256 cellar: :any, x86_64_linux:      "8a18464fa1fbf7502084117fdc933314de11f619931c4dbd97a2613e1a6aa8f7"
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
