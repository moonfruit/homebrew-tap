class LzcCli < Formula
  desc "Client for Lazycat hardware"
  homepage "https://www.npmjs.com/package/@lazycatcloud/lzc-cli"
  url "https://registry.npmjs.org/@lazycatcloud/lzc-cli/-/lzc-cli-2.0.9.tgz"
  sha256 "78ae56ee70992b64a57718b14e22594934db2500d42e35c1998db47970636ad2"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "9157f5ab9a35091a6673f725063129e407f40e07549ad3e50cc3f9a5f25a0797"
    sha256 cellar: :any, arm64_tahoe:       "3f80d051c121c8cd0a93fd4a4bfcc8c44fe1995fbf5971bf800352895d62428b"
    sha256 cellar: :any, arm64_linux:       "0458e6b5ae4c47e3d16a7af46d11f24ce53cd22a9cffe992b06eb648f49c8cda"
    sha256 cellar: :any, x86_64_linux:      "8a7439d32bf655f6690867108d79849fd6a7ae7956a7487d3373c468c36f2172"
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
