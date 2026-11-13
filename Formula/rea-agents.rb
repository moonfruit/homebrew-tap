class ReaAgents < Formula
  desc "Reverse engineer anything from your terminal or agent via CLI and MCP"
  homepage "https://github.com/morluto/rea"
  url "https://registry.npmjs.org/rea-agents/-/rea-agents-6.9.0.tgz"
  sha256 "322338a1505e2557702a16012e7d46abdb5729641d98938662762dfbfb79262a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f0904c04c8d2ac1ec53da5fd4cbae03af619ba355201b9329b21cd4a05ceb1a0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f0904c04c8d2ac1ec53da5fd4cbae03af619ba355201b9329b21cd4a05ceb1a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "05eaf13fcc1ecad220ab1d1d4d267c8358eaff313c3754860c5950a36c42b533"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b5624aa1ca8e0b70375486f76bbeb515d8b6c1b86fc102c35e0c13803cdd7988"
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
