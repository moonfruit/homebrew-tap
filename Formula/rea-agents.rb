class ReaAgents < Formula
  desc "Reverse engineer anything from your terminal or agent via CLI and MCP"
  homepage "https://github.com/morluto/rea"
  url "https://registry.npmjs.org/rea-agents/-/rea-agents-6.3.0.tgz"
  sha256 "b169fc63c0710d44c5c44c59c2f871f22479df44477cdfaa9f2e5c37c4563a84"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e9dc9363f18c261551ac3c3e805072f7020d4429dc3a31fdfd3b7a491759ebf5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e9dc9363f18c261551ac3c3e805072f7020d4429dc3a31fdfd3b7a491759ebf5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "81b04cf86764e29942865d94f74094f3b224be5fc9c5ff068f95c4e840ee1b38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "88c46fedb32b0deb7d0b60bc5b53e3dd99d85f3eac79acabdf0258a4d0907bb2"
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
