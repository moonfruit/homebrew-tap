class Codegraph < Formula
  desc "Local-first code intelligence for AI agents via MCP"
  homepage "https://github.com/colbymchenry/codegraph"
  url "https://registry.npmjs.org/@colbymchenry/codegraph/-/codegraph-1.6.0.tgz"
  sha256 "832d2f608d2366ab48411a8123f91889c4a44407b8b87f3595276e29fd4e0129"
  license "MIT"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any,                 arm64_golden_gate: "f31105e8ed7272a3ef62ca62fd10e035de87708750f8762f44ef262748391295"
    sha256 cellar: :any,                 arm64_tahoe:       "f31105e8ed7272a3ef62ca62fd10e035de87708750f8762f44ef262748391295"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "69705965da32ccf0a6dd44c57abff8ff73827134f54346f4ab3a3b56b73b1a42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "9d8eb0a991de6792240f19f5a4a99c456e82a1b76808730f71225460ee1c577f"
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
