class ClaudeMem < Formula
  desc "Persistent memory compression system for Claude Code"
  homepage "https://github.com/thedotmack/claude-mem"
  url "https://registry.npmjs.org/claude-mem/-/claude-mem-16.0.0.tgz"
  sha256 "511770c7b0a1b36ac01dc2f4a356ce19cfbe8b170c46f90324c99488f450d875"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256               arm64_golden_gate: "ac79215b056bba1570961a41f30d61551450ce0700bd8cc0760e127e26b91b29"
    sha256               arm64_tahoe:       "ac79215b056bba1570961a41f30d61551450ce0700bd8cc0760e127e26b91b29"
    sha256 cellar: :any, arm64_linux:       "d2534851b26c05ba4ce2ded9d4bd736bc0e48cb131ab44455b241ee392c76bf1"
    sha256 cellar: :any, x86_64_linux:      "a8bfa24e12e901e883a7bec11a56fba72399a0e1dcf97efa40d8b2f735503702"
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
