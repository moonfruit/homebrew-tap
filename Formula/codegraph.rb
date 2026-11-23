class Codegraph < Formula
  desc "Local-first code intelligence for AI agents via MCP"
  homepage "https://github.com/colbymchenry/codegraph"
  url "https://registry.npmjs.org/@colbymchenry/codegraph/-/codegraph-1.6.4.tgz"
  sha256 "194d6b88170d5f36c25ba87c6d4177b17d7d951a9ffb4b5841ebc8d5d6eeda83"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    manifest_sha256 "09646365786fbbb7e8eeb87d99a3e1732587e43eb88643e07b07d2ba52775d3c"
    sha256 cellar: :any,                 arm64_golden_gate: "12a1387bfd667325f034990d1614d8736743c8b70f6c2e9ca37e677d8a5fe4a8"
    sha256 cellar: :any,                 arm64_tahoe:       "12a1387bfd667325f034990d1614d8736743c8b70f6c2e9ca37e677d8a5fe4a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5a241e27d539b1fe0b86a0e8fd8426c72c819433d52cbc54bb6faca2da7d37d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ccc21239dec02edbbf109c7ccdf69a1391fd5bf67460df8ea696964c660d16ad"
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
