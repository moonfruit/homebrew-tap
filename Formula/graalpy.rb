class Graalpy < Formula
  desc "GraalVM implementation of Python"
  homepage "https://www.graalvm.org/python/"
  version "25.6.5"
  license :cannot_represent # GraalVM Free Terms and Conditions

  if OS.mac?
    url "https://github.com/oracle/graalpython/releases/download/graal-#{version}/graalpy3.13-#{version}-macos-aarch64.tar.gz"
    sha256 "7c01562f074c1c3f75c412ce6ec2a27a6feaa5337525983665cdac1d9f081633"
  elsif Hardware::CPU.arm?
    url "https://github.com/oracle/graalpython/releases/download/graal-#{version}/graalpy3.13-#{version}-linux-aarch64.tar.gz"
    sha256 "b8568470a622bc29c2e2dffead099b23b06b805d3bd76ea6aacc446087cc02dd"
  else
    url "https://github.com/oracle/graalpython/releases/download/graal-#{version}/graalpy3.13-#{version}-linux-amd64.tar.gz"
    sha256 "c8f10df34606a4c0b19b75ad2e2ff9c75b2215b372bc21b36763b89d3adf5568"
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
