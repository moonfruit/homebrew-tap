class ZaiMcpServer < Formula
  desc "MCP server for Z.AI image and video analysis"
  homepage "https://docs.z.ai/"
  url "https://registry.npmjs.org/@z_ai/mcp-server/-/mcp-server-0.1.6.tgz"
  sha256 "6cf67aedbd9f5ba50140cbf5d2b0ae2dae1117ec4b1540cf63eefdbee5401c52"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, all: "23c52681380c16eec15ed79acd9dda9e1dc98facefa77e580de565d2511ed3e1"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    ENV["Z_AI_API_KEY"] = "test"
    request = {
      jsonrpc: "2.0", id: 1, method: "initialize",
      params: {
        protocolVersion: "2025-03-26", capabilities: {},
        clientInfo: { name: "homebrew", version: "1.0" }
      }
    }
    response = JSON.parse(pipe_output(bin/"zai-mcp-server", "#{request.to_json}\n"))
    assert_equal "zai-mcp-server", response.dig("result", "serverInfo", "name")
  end
end
