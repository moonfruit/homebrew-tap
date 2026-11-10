class SonarqubeMcpServer < Formula
  desc "Code quality and security tools for AI agents via SonarQube"
  homepage "https://github.com/SonarSource/sonarqube-mcp-server"
  url "https://github.com/SonarSource/sonarqube-mcp-server/archive/refs/tags/1.32.0.5118.tar.gz"
  sha256 "b9be1421f16e1f89509eee09355b2f3bf079ee60d9c7438e790d2d3922400480"
  license :cannot_represent # Sonar Source-Available License v1.0

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f639b74144cd7c7d08aa25316b728b53874dae8de92ffeaefde0b375ce76751c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f639b74144cd7c7d08aa25316b728b53874dae8de92ffeaefde0b375ce76751c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fda7faba95908405e29a52c590a74a98023aaf5764c737191188d9dea4cfd6cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "fda7faba95908405e29a52c590a74a98023aaf5764c737191188d9dea4cfd6cd"
  end

  depends_on "gradle" => :build
  depends_on "openjdk"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home
    inreplace "build.gradle.kts", "JavaLanguageVersion.of(21)",
                                 "JavaLanguageVersion.of(#{Formula["openjdk"].version.major})"
    system "gradle", "--no-daemon", "--no-build-cache", "-Pversion=#{version}", "jar"
    libexec.install "build/libs/sonarqube-mcp-server-#{version}.jar" => "sonarqube-mcp-server.jar"
    bin.write_jar_script libexec/"sonarqube-mcp-server.jar", "sonarqube-mcp-server",
                         '-DSTORAGE_PATH="${STORAGE_PATH:-$HOME/.sonarqube-mcp-server}"'
  end

  def caveats
    <<~EOS
      For stdio transport, set SONARQUBE_TOKEN and either SONARQUBE_URL
      (SonarQube Server) or SONARQUBE_ORG (SonarQube Cloud) in your MCP client.
      Use #{opt_bin}/sonarqube-mcp-server as the command.

      Storage defaults to ~/.sonarqube-mcp-server; override with STORAGE_PATH.
    EOS
  end

  test do
    ENV["STORAGE_PATH"] = testpath/"storage"
    ENV["TELEMETRY_DISABLED"] = "true"
    ENV["SONARQUBE_URL"] = "http://127.0.0.1:9000"
    ENV.delete "SONARQUBE_TOKEN"
    ENV.delete "SONARQUBE_TRANSPORT"

    request = {
      jsonrpc: "2.0", id: 1, method: "initialize",
      params: {
        protocolVersion: "2025-03-26", capabilities: {},
        clientInfo: { name: "homebrew", version: "1.0" }
      }
    }
    response = JSON.parse(pipe_output(bin/"sonarqube-mcp-server", "#{request.to_json}\n", 1))
    assert_equal 1, response["id"]
    assert_match "SONARQUBE_TOKEN environment variable or property must be set", response.dig("error", "message")
  end
end
