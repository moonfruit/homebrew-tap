class Codegraph < Formula
  desc "Local-first code intelligence for AI agents via MCP"
  homepage "https://github.com/colbymchenry/codegraph"
  url "https://registry.npmjs.org/@colbymchenry/codegraph/-/codegraph-1.6.1.tgz"
  sha256 "0cfcdbffbb49aa098713587bdb8a486d5e5354b04f4b22acee56ccf450d429ed"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any,                 arm64_golden_gate: "466527e3dc3dee686f854d7ae3eff891b925b8e22a8a97b09889034eb3ed04c4"
    sha256 cellar: :any,                 arm64_tahoe:       "466527e3dc3dee686f854d7ae3eff891b925b8e22a8a97b09889034eb3ed04c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6a3d5f7da159a780e6359201e7e0e32edb70cd748aa3466d17f785e9aa010d48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "3516c58499cbc7d799adc7cac7607661d82c092a5e29741eb64bfbb3b3cf169e"
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
