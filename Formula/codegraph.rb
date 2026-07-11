class Codegraph < Formula
  desc "Local-first code intelligence for AI agents via MCP"
  homepage "https://github.com/colbymchenry/codegraph"
  url "https://registry.npmjs.org/@colbymchenry/codegraph/-/codegraph-1.4.1.tgz"
  sha256 "8d34d4ef8ef3bc0b5236ca0ba17c3806eee3d9a681699cc76a0eb7552b0da047"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "05612dd5da57397f7c789d091b44b0bafc80aa971267486f67f217a830608d46"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "bb44953db8c8157bf587b575048426ecc4344061d367b00796c5c276043003e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "490bda8498ee0c376bc0c7d3bc0ebaf7428bf11dff695b0108d237fbc06a6f08"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codegraph --version")
  end
end
