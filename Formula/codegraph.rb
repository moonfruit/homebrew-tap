class Codegraph < Formula
  desc "Local-first code intelligence for AI agents via MCP"
  homepage "https://github.com/colbymchenry/codegraph"
  url "https://registry.npmjs.org/@colbymchenry/codegraph/-/codegraph-1.6.4.tgz"
  sha256 "194d6b88170d5f36c25ba87c6d4177b17d7d951a9ffb4b5841ebc8d5d6eeda83"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any,                 arm64_golden_gate: "8fc5b3dfc3fcceb09bfb59991acaaa55914313d9b7688c0e73fc2b026156335d"
    sha256 cellar: :any,                 arm64_tahoe:       "8fc5b3dfc3fcceb09bfb59991acaaa55914313d9b7688c0e73fc2b026156335d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "73d358170ac4657cd42e04b904b6ffa083771b3a1f4faadb6a289eeaf387ed52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "3e292465f258eed244d18a78c3ad2cfe894476e2f4d633c6ff37d43f7a8b22ba"
  end

  depends_on "node" => :test
  # Upstream blocks Node >= 25 (V8 turboshaft WASM Zone OOM), see
  # https://github.com/colbymchenry/codegraph/issues/81
  depends_on "node@24"

  def install
    system "npm", "install", *std_npm_args
    # Use node@24 instead of the vendored Node runtime
    bundle = libexec.glob("lib/node_modules/@colbymchenry/codegraph/node_modules/@colbymchenry/codegraph-*")
                    .first.relative_path_from(libexec)
    rm libexec/bundle/"node"
    (bin/"codegraph").write <<~SH
      #!/bin/bash
      exec "#{formula_opt_bin("node@24")}/node" --liftoff-only --disable-warning=ExperimentalWarning \\
        "#{opt_libexec}/#{bundle}/lib/dist/bin/codegraph.js" "$@"
    SH
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codegraph --version")

    # When this fails, upstream supports the latest Node again:
    # switch back to `depends_on "node"` and drop this check
    entry = libexec.glob("lib/node_modules/@colbymchenry/codegraph/node_modules/@colbymchenry/codegraph-*").first
    output = shell_output("#{formula_opt_bin("node")}/node #{entry}/lib/dist/bin/codegraph.js --version 2>&1", 1)
    assert_match "Unsupported Node.js version", output
  end
end
