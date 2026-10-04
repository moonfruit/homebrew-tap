class Codegraph < Formula
  desc "Local-first code intelligence for AI agents via MCP"
  homepage "https://github.com/colbymchenry/codegraph"
  url "https://registry.npmjs.org/@colbymchenry/codegraph/-/codegraph-1.6.2.tgz"
  sha256 "80cb635659cdb21f25bb882331bc82e0180d42e80550186712e12ab0e04082ea"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any,                 arm64_golden_gate: "3aef52cb650c3556f9433aa84f3067338f10daa2cdb6be9da3299e52456e4516"
    sha256 cellar: :any,                 arm64_tahoe:       "3aef52cb650c3556f9433aa84f3067338f10daa2cdb6be9da3299e52456e4516"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e47cdec65ffabe7ba3d7a8d21ba04dccac98ad3e9a3fc7fb009ce9765ea2465e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "dc31a0f1a34e4d78652ca1815175eeb28b48db0576fb36dfc4873a7b731e5ade"
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
