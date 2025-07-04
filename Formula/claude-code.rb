class ClaudeCode < Formula
  desc "Agentic coding tool that helps you code faster from your terminal"
  homepage "https://docs.anthropic.com/en/docs/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-1.0.41.tgz"
  sha256 "1e513c256a7b71e89f6b8fdf2da2f1f486efa38c5bcb6c3f8bc6b802812965be"
  license :cannot_represent

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    arch_os = if Hardware::CPU.arm?
      "arm64"
    else
      "x64"
    end

    arch_os = if OS.mac?
      arch_os + "-darwin"
    else
      arch_os + "-linux"
    end

    rm Dir["#{libexec}/**/ripgrep/*/**"] - Dir["#{libexec}/**/ripgrep/#{arch_os}/**"]
  end

  test do
    assert_match "#{version} (Claude Code)", shell_output("#{bin}/claude --version")
  end
end
