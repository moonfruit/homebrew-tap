class Graalpy < Formula
  desc "GraalVM implementation of Python"
  homepage "https://www.graalvm.org/python/"
  version "25.4.4"
  license :cannot_represent # GraalVM Free Terms and Conditions

  if OS.mac?
    url "https://github.com/oracle/graalpython/releases/download/graal-#{version}/graalpy3.13-#{version}-macos-aarch64.tar.gz"
    sha256 "aacd819b5c3b6889b6a6275d8009ec1e8e3fe27cf7b77265710a1c9ea931bedd"
  elsif Hardware::CPU.arm?
    url "https://github.com/oracle/graalpython/releases/download/graal-#{version}/graalpy3.13-#{version}-linux-aarch64.tar.gz"
    sha256 "1323dc064583efd1d6b696d3a9f9e4b1ff8facd0f7cc2b69fe0a0bf7ef06ea1a"
  else
    url "https://github.com/oracle/graalpython/releases/download/graal-#{version}/graalpy3.13-#{version}-linux-amd64.tar.gz"
    sha256 "8b72e6e513d06976e5c8e051228d69d541fde76d05d5f907eaef4bb31db83af4"
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    depends_on arch: :arm64
  end

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/graalpy"
  end

  def caveats
    <<~EOS
      Oracle GraalVM license: https://www.oracle.com/downloads/licenses/graal-free-license.html
    EOS
  end

  test do
    assert_equal "42", shell_output("#{bin}/graalpy -c 'import json; print(json.loads(\"42\"))'").strip
    system bin/"graalpy", "-m", "venv", testpath/"venv"
    assert_equal "42", shell_output("#{testpath}/venv/bin/python -c 'print(6 * 7)'").strip
  end
end
