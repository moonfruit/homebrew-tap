class ReaAgents < Formula
  desc "Reverse engineer anything from your terminal or agent via CLI and MCP"
  homepage "https://github.com/morluto/rea"
  url "https://registry.npmjs.org/rea-agents/-/rea-agents-6.1.0.tgz"
  sha256 "f997f603b3f1fb8f06593ef2d57989e43cddbd7526c45bcec92ce61d2873ad31"
  license "MIT"

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
