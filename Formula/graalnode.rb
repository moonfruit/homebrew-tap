class Graalnode < Formula
  desc "GraalVM implementation of Node.js"
  homepage "https://www.graalvm.org/javascript/"
  version "25.4.4.1.1"
  license :cannot_represent # GraalVM Free Terms and Conditions

  if OS.mac?
    url "https://github.com/oracle/graaljs/releases/download/graal-#{version}/graalnode24-#{version}-macos-aarch64.tar.gz"
    sha256 "18fd8f5b3f3d84fa0d2cbdbbf8deda2c518e265e9c146c7d503b5ebebba4e809"
  elsif Hardware::CPU.arm?
    url "https://github.com/oracle/graaljs/releases/download/graal-#{version}/graalnode24-#{version}-linux-aarch64.tar.gz"
    sha256 "daacf73e3adfa62f653b73e882e94953bfc94a7c4a3fb548fe0a68a8f47d6e0e"
  else
    url "https://github.com/oracle/graaljs/releases/download/graal-#{version}/graalnode24-#{version}-linux-amd64.tar.gz"
    sha256 "33a633a33954350a44895e0d38a121b8af730f908a4f971b978156f5a7fcddf7"
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
