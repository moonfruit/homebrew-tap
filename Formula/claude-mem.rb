class ClaudeMem < Formula
  desc "Persistent memory compression system for Claude Code"
  homepage "https://github.com/thedotmack/claude-mem"
  url "https://registry.npmjs.org/claude-mem/-/claude-mem-15.9.0.tgz"
  sha256 "9d4a2fd7e19077452a803d6e6b0e3f07d6983a241b96758b6d43648806bff531"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256               arm64_golden_gate: "f9cc213c554a86913c1a9cd01198ac721dc0edc3a9ba689a0b2b4f5280cb5245"
    sha256               arm64_tahoe:       "f9cc213c554a86913c1a9cd01198ac721dc0edc3a9ba689a0b2b4f5280cb5245"
    sha256 cellar: :any, arm64_linux:       "dd44ac40503423169a6f45a9b03e403677195b8827ad8486aaf9889b1fd29fa2"
    sha256 cellar: :any, x86_64_linux:      "e48afa834d36365da988fa1006c0605df5fb06dc19f9c9946d391d25a9754c6c"
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
