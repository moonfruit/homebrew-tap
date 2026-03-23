class DashMcpServer < Formula
  include Language::Python::Virtualenv

  desc "MCP server for Dash, the macOS API documentation browser"
  homepage "https://github.com/Kapeli/dash-mcp-server"
  url "https://github.com/Kapeli/dash-mcp-server/archive/758926ae996b7271e338f79bdd90caf4971e15dd.tar.gz"
  version "1.1.0.1773736488"
  sha256 "5e073908dd3bd5a7d09a5f3ffdc7c88cbcdd0bbb94e2dc6e73fd87eb7793b3a4"
  license "MIT"
  revision 1
  head "https://github.com/Kapeli/dash-mcp-server.git", branch: "main"

  livecheck do
    url "https://api.github.com/repos/Kapeli/dash-mcp-server/branches/main"
    strategy :json do |json|
      date = json.dig("commit", "commit", "author", "date")
      "1.1.0.#{DateTime.parse(date).strftime("%s")}"
    end
  end

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "ff6d5771b1af3e3be73a084a8e02efc72d1171c2a3e3a09d2393b71f002ea4b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6980cd553186bc92fe75fae0c40582f4893e86853092bdbc8f708ed920552df2"
  end

  depends_on "uv" => :build
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "pydantic"
  depends_on "python@3.14"
  depends_on "rpds-py"

  def install
    virtualenv_create(libexec)

    excludes = buildpath/"excludes.txt"
    excludes.write <<~TXT
      certifi
      cffi
      cryptography
      pycparser
      pydantic
      pydantic-core
      annotated-types
      rpds-py
      typing-extensions
      typing-inspection
    TXT
    system "uv", "pip", "install", "--python", libexec/"bin/python", ".", "--excludes", excludes

    bin.install_symlink libexec/"bin/dash-mcp-server"
  end

  test do
    request = {
      jsonrpc: "2.0",
      id:      1,
      method:  "initialize",
      params:  {
        protocolVersion: "2024-11-05",
        capabilities:    {},
        clientInfo:      { name: "test", version: "0.1" },
      },
    }
    response = pipe_output(bin/"dash-mcp-server", "#{request.to_json}\n", 0)
    assert_match "Dash Documentation API", response
  end
end
