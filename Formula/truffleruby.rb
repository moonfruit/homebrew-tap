class Truffleruby < Formula
  desc "GraalVM implementation of Ruby"
  homepage "https://github.com/truffleruby/truffleruby"
  version "40.0.0"
  license :cannot_represent # GraalVM Free Terms and Conditions

  if OS.mac?
    url "https://github.com/truffleruby/truffleruby/releases/download/graal-#{version}/truffleruby-#{version}-macos-aarch64.tar.gz"
    sha256 "f37d33d7d58c9cbaa0dd6eacc508a596a74d053ad476d47bcefebe63fbec1547"
  elsif Hardware::CPU.arm?
    url "https://github.com/truffleruby/truffleruby/releases/download/graal-#{version}/truffleruby-#{version}-linux-aarch64.tar.gz"
    sha256 "2da27d27edff77e3d94f9baeb90ee64d7a60c5603b7be3b12fd64324c15090f2"
  else
    url "https://github.com/truffleruby/truffleruby/releases/download/graal-#{version}/truffleruby-#{version}-linux-amd64.tar.gz"
    sha256 "ecd071f9c051d1e3fc40c3b97e39e822d5157c2f8703f34f2f08e04305f05f52"
  end

  on_macos do
    depends_on arch: :arm64
  end

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/truffleruby"
  end

  def caveats
    <<~EOS
      To use ruby, gem and bundle from this distribution, add to your PATH:
        #{opt_libexec}/bin

      Oracle GraalVM license: https://www.oracle.com/downloads/licenses/graal-free-license.html
    EOS
  end

  test do
    assert_equal "42", shell_output("#{bin}/truffleruby -rjson -e 'puts JSON.parse(\"42\")'").strip
    ENV.prepend_path "PATH", libexec/"bin"
    system libexec/"bin/gem", "--version"
  end
end
