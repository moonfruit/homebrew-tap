require "formula_installer"

FormulaInstaller.class_eval do
  define_method(:fix_dynamic_linkage) do |_keg|
    nil
  end
end

class Serena < Formula
  include Language::Python::Virtualenv

  desc "Coding agent toolkit providing semantic code retrieval and editing via MCP"
  homepage "https://oraios.github.io/serena"
  url "https://github.com/oraios/serena/archive/8c62b0d991f280af62531fb2c62bd1bb3310f0d4.tar.gz"
  version "0.1.4"
  sha256 "2ef8722bd85ba6fec22e12f3e8ab1da35f24cab2379528a1e5daea1f5bbd87ae"
  license "MIT"
  head "https://github.com/oraios/serena.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 arm64_tahoe:  "daa256eb91011c2adec47502377ac83206b64faafe58101990492fc32bf078d1"
    sha256 x86_64_linux: "67c0303f80dc03b243b10036f357a3a0869fc12674d0e19548d0d4e66169b3cc"
  end

  depends_on "uv" => :build
  depends_on "certifi"
  depends_on "cryptography"
  depends_on :macos
  depends_on "pydantic"
  depends_on "python-packaging"
  depends_on "python@3.14"
  depends_on "rpds-py"

  def install
    virtualenv_create(libexec)

    excludes = buildpath/"excludes.txt"
    excludes.write <<~TXT
      certifi
      cffi
      cryptography
      packaging
      pycparser
      pydantic
      pydantic-core
      annotated-types
      rpds-py
      typing-extensions
      typing-inspection
    TXT
    system "uv", "pip", "install", "--python", libexec/"bin/python", ".", "--excludes", excludes

    bin.install_symlink libexec/"bin/serena"
    bin.install_symlink libexec/"bin/serena-mcp-server"
  end

  test do
    assert_match "serena", shell_output("#{bin}/serena --help")

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
    response = pipe_output("#{bin}/serena-mcp-server --enable-web-dashboard false", "#{request.to_json}\n", 0)
    assert_match "Serena", response
  end
end
