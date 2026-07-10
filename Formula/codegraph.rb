class Codegraph < Formula
  desc "Local-first code intelligence for AI agents via MCP"
  homepage "https://github.com/colbymchenry/codegraph"
  url "https://registry.npmjs.org/@colbymchenry/codegraph/-/codegraph-1.3.1.tgz"
  sha256 "0a101aa5f2be60acc389d18ac67db5fece1b972da175947a4e316b7b5f950e5b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "364bb95640b9c015c482b4142ca069e4a8075120cff9dc7fd2fb2176db1970d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "c05bed23b2fe428700719be1ee62c91740afcc854aca4f210fdfd2196aa13b53"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1479667bea239d3b9979c4bf0b6f893b818e806b20461d84d350b2afab908bf6"
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
