class LzcCli < Formula
  desc "Client for Lazycat hardware"
  homepage "https://www.npmjs.com/package/@lazycatcloud/lzc-cli"
  url "https://registry.npmjs.org/@lazycatcloud/lzc-cli/-/lzc-cli-2.0.5.tgz"
  sha256 "55f85c2f1a3a31f2114a1921ece7be193ea85650814d9c67b26a5b21f1f80dde"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any,                 arm64_tahoe:  "35088d132cad99a3423a2b2f01da19d63fc8e44712e4eae403fbf9cbd82261b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "49076ebe4635f38f25c96a0831fc04728b4f1085278001c31a28a9f0b225669f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e2482f8e6032e77363c309974c61510b15808004aee3f0a0fdb58710170ee01f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args

    cpu = Hardware::CPU.arm? ? "arm64" : "x64"
    os  = OS.mac? ? "darwin" : "linux"

    Dir[libexec/"**/dprint-node.*.node"].each do |f|
      name = File.basename(f)
      rm(f) if name.exclude?("#{os}-#{cpu}") || name.include?("-musl")
    end

    Dir[libexec/"**/prebuilds/*"].each do |d|
      rm_r(d) if File.directory?(d) && File.basename(d) != "#{os}-#{cpu}"
    end

    rm Dir[libexec/"**/_lpk/busybox-*"] if Hardware::CPU.arm?

    bin.install_symlink Dir["#{libexec}/bin/*"]

    generate_completions_from_executable(bin/"lzc-cli", "completion", shells: [:bash, :zsh])
  end

  test do
    assert_match "lzc-cli #{version}", shell_output("#{bin}/lzc-cli --version")
  end
end
