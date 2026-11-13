class ReaAgents < Formula
  desc "Reverse engineer anything from your terminal or agent via CLI and MCP"
  homepage "https://github.com/morluto/rea"
  url "https://registry.npmjs.org/rea-agents/-/rea-agents-6.9.0.tgz"
  sha256 "322338a1505e2557702a16012e7d46abdb5729641d98938662762dfbfb79262a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9722a3350fd8080ae913a7fba465a4c1c8c39ecc3ca198f9c6528de655f78dd7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9722a3350fd8080ae913a7fba465a4c1c8c39ecc3ca198f9c6528de655f78dd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4ad3eafc3f4bdcf6169e3baab4eed4cb048fea80aec2d53a24df6851e55b2e47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "3b3ed063cfb0dc45b0f2537623a530aebd2206a6be15747a870f7a9b1e0759bf"
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
