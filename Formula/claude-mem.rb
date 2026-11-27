class ClaudeMem < Formula
  desc "Persistent memory compression system for Claude Code"
  homepage "https://github.com/thedotmack/claude-mem"
  url "https://registry.npmjs.org/claude-mem/-/claude-mem-17.0.2.tgz"
  sha256 "66d00edd8ecb11b7c019d37dcf3504f1e701bbb733f1eb8ebd0dadf43a36cebf"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    manifest_sha256 "8feb30da3e4a2a491607164757313c282b6c6ada7ee890242e5d6d0dd72103a5"
    sha256               arm64_golden_gate: "05194742f6d12a4d50c022855ec600fbd57b9e41686b09fc77155f9ec37e1c5c"
    sha256               arm64_tahoe:       "05194742f6d12a4d50c022855ec600fbd57b9e41686b09fc77155f9ec37e1c5c"
    sha256 cellar: :any, arm64_linux:       "7a4cb7353fc82b524f3cb4401654dd8a7423b472152f57d2b93f09e0aeccf073"
    sha256 cellar: :any, x86_64_linux:      "d098b6e595ef1739bfd3512504043d0f57113f2b3050d136614f2f4f7f9bb191"
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
