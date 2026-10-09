class ReaAgents < Formula
  desc "Reverse engineer anything from your terminal or agent via CLI and MCP"
  homepage "https://github.com/morluto/rea"
  url "https://registry.npmjs.org/rea-agents/-/rea-agents-6.1.0.tgz"
  sha256 "f997f603b3f1fb8f06593ef2d57989e43cddbd7526c45bcec92ce61d2873ad31"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a655a849516b41d19a4a04fcbee1b7394c8773e6cc340552dc72607f9580a80c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a655a849516b41d19a4a04fcbee1b7394c8773e6cc340552dc72607f9580a80c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "32dfa12e54fcbe7b438fc185c2ba41acc40331fa481c34f2b5e5e3e8bc514e1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "e6e014bac2eecc01479208d94e73d92aee6efe923ff61b0cf82329821dbbd039"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove prebuilt binaries for unsupported platforms
    rm_r libexec/"lib/node_modules/rea-agents/native/windows"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rea --version")
  end
end
