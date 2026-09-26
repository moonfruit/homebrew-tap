class Codegraph < Formula
  desc "Local-first code intelligence for AI agents via MCP"
  homepage "https://github.com/colbymchenry/codegraph"
  url "https://registry.npmjs.org/@colbymchenry/codegraph/-/codegraph-1.6.0.tgz"
  sha256 "832d2f608d2366ab48411a8123f91889c4a44407b8b87f3595276e29fd4e0129"
  license "MIT"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    rebuild 2
    sha256 cellar: :any,                 arm64_golden_gate: "3340923cc991fbcdab4d26c0695d80abe905a046f308ca449337212be339e94b"
    sha256 cellar: :any,                 arm64_tahoe:       "3340923cc991fbcdab4d26c0695d80abe905a046f308ca449337212be339e94b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "62d9d3211a7d7fbc460594ba39b30c1117f55fe1551cafff000512c906da2495"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "7c3c2774e25065ac35d2935cbc3c19a91eec13ae268458fe0a17fcdc8442a34d"
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
