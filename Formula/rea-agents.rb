class ReaAgents < Formula
  desc "Reverse engineer anything from your terminal or agent via CLI and MCP"
  homepage "https://github.com/morluto/rea"
  url "https://registry.npmjs.org/rea-agents/-/rea-agents-6.10.1.tgz"
  sha256 "e8cf08c9fa954e998fc8868c23fa8e5f518cdb9553488ec227b31a3bb6903150"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    manifest_sha256 "53a9d94ee1677155f0df36276df9bc44d9ac0ca186e5c0aea5274aae1513dd5f"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "55bd62c325b71342ae63b27a32e4503e7766f2dac79642b5713bb647170d0804"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "55bd62c325b71342ae63b27a32e4503e7766f2dac79642b5713bb647170d0804"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6aa92d8b8ed0d9d3821b56432cf558aed58394739ec3c111d9d6226089c429cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "54bceee54684dbceb4a8018b9fe5cad30aaeed1ee44e9e08eaa4651dfcde993a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove prebuilt binaries for unsupported platforms
    rm_r libexec/"lib/node_modules/rea-agents/native/windows"

    # frida's mocha test fixtures ship non-native unixvictim binaries
    rm_r libexec/"lib/node_modules/rea-agents/node_modules/frida/test"

    # The npm tarball bundles node-pty binaries for every supported platform.
    os = OS.mac? ? "darwin" : "linux"
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    libexec.glob("lib/node_modules/rea-agents/node_modules/@lydell/node-pty-*").each do |platform|
      rm_r platform if platform.basename.to_s != "node-pty-#{os}-#{arch}"
    end

    generate_completions_from_executable(bin/"rea", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rea --version")
  end
end
