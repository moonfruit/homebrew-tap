class ReaAgents < Formula
  desc "Reverse engineer anything from your terminal or agent via CLI and MCP"
  homepage "https://github.com/morluto/rea"
  url "https://registry.npmjs.org/rea-agents/-/rea-agents-6.1.0.tgz"
  sha256 "f997f603b3f1fb8f06593ef2d57989e43cddbd7526c45bcec92ce61d2873ad31"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a93296e9729fa117d8b620e37bf0a594ca4d484686b629651bb9bf090b8c9934"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a93296e9729fa117d8b620e37bf0a594ca4d484686b629651bb9bf090b8c9934"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b64899da63dc5596063705a72d3e966ae545fcf6827999c0a28b17ccce3a2d59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "d6876b24ba920a8c361325ef20e0457798908a4817e6147b02add20624927cb3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove prebuilt binaries for unsupported platforms
    rm_r libexec/"lib/node_modules/rea-agents/native/windows"

    generate_completions_from_executable(bin/"rea", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rea --version")
  end
end
