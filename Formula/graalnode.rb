class Graalnode < Formula
  desc "GraalVM implementation of Node.js"
  homepage "https://www.graalvm.org/javascript/"
  version "25.6.5.1"
  license :cannot_represent # GraalVM Free Terms and Conditions

  if OS.mac?
    url "https://github.com/oracle/graaljs/releases/download/graal-#{version}/graalnode24-#{version}-macos-aarch64.tar.gz"
    sha256 "ff6a3d1227c57b0185a907f3d42943e4879f11e18fc2056ab2e8dab7c1a4084a"
  elsif Hardware::CPU.arm?
    url "https://github.com/oracle/graaljs/releases/download/graal-#{version}/graalnode24-#{version}-linux-aarch64.tar.gz"
    sha256 "4a076df5847f606c118940c4b0b3a71b88885a8d11235b9d294d1098dd9b5f85"
  else
    url "https://github.com/oracle/graaljs/releases/download/graal-#{version}/graalnode24-#{version}-linux-amd64.tar.gz"
    sha256 "0bbfc5eae41bfc1995031b050767ec639b7dd8bc4d0244dc052408e703580b25"
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
