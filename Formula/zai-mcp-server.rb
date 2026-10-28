class ZaiMcpServer < Formula
  desc "MCP server for Z.AI image and video analysis"
  homepage "https://docs.z.ai/"
  url "https://registry.npmjs.org/@z_ai/mcp-server/-/mcp-server-0.1.5.tgz"
  sha256 "7da4109110e39f5b521f2e5ab08f23b53a22f2019f070313fa011f096e9ed415"
  license "Apache-2.0"

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
    assert_equal version.to_s, response.dig("result", "serverInfo", "version")
  end
end
