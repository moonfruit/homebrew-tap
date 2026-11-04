class Graalnode < Formula
  desc "GraalVM implementation of Node.js"
  homepage "https://www.graalvm.org/javascript/"
  version "25.5.5.0.3"
  license :cannot_represent # GraalVM Free Terms and Conditions

  if OS.mac?
    url "https://github.com/oracle/graaljs/releases/download/graal-#{version}/graalnode24-#{version}-macos-aarch64.tar.gz"
    sha256 "275a6cbde73a3411f266d7155afb86d5c8c052aeb29c0e92cf62c9ba039f95eb"
  elsif Hardware::CPU.arm?
    url "https://github.com/oracle/graaljs/releases/download/graal-#{version}/graalnode24-#{version}-linux-aarch64.tar.gz"
    sha256 "a6619c2c66a5674e26bb925ac03df09884b3c8b39cb53974c14b9a1dcdb8e87b"
  else
    url "https://github.com/oracle/graaljs/releases/download/graal-#{version}/graalnode24-#{version}-linux-amd64.tar.gz"
    sha256 "36d774ee5e030c1616963e120cb2f2cd4c440297db003abfe334ff6d7d983613"
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
    bin.install_symlink libexec/"bin/node" => "graalnode"
  end

  def caveats
    <<~EOS
      To use node, npm and npx from this distribution, add to your PATH:
        #{opt_libexec}/bin

      Oracle GraalVM license: https://www.oracle.com/downloads/licenses/graal-free-license.html
    EOS
  end

  test do
    assert_equal "42", shell_output("#{bin}/graalnode -e 'console.log(require(\"path\").basename(\"/42\"))'").strip
    ENV.prepend_path "PATH", libexec/"bin"
    system libexec/"bin/npm", "--version"
  end
end
