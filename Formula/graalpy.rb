class Graalpy < Formula
  desc "GraalVM implementation of Python"
  homepage "https://www.graalvm.org/python/"
  version "25.5.5"
  license :cannot_represent # GraalVM Free Terms and Conditions

  if OS.mac?
    url "https://github.com/oracle/graalpython/releases/download/graal-#{version}/graalpy3.13-#{version}-macos-aarch64.tar.gz"
    sha256 "3228f2075a02d1a614f5584b53707565c37d7c24dc9bcd8b4812e413db377da6"
  elsif Hardware::CPU.arm?
    url "https://github.com/oracle/graalpython/releases/download/graal-#{version}/graalpy3.13-#{version}-linux-aarch64.tar.gz"
    sha256 "f9a7b3a572c8a907cf517647f1f58f02e241f08a66da73bb1174493b15f91233"
  else
    url "https://github.com/oracle/graalpython/releases/download/graal-#{version}/graalpy3.13-#{version}-linux-amd64.tar.gz"
    sha256 "b4ff1358c47d832f48e334bdabff2d632fcf9670519cee50694ffc38bc01dab6"
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
