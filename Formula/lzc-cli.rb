class LzcCli < Formula
  desc "Client for Lazycat hardware"
  homepage "https://www.npmjs.com/package/@lazycatcloud/lzc-cli"
  url "https://registry.npmjs.org/@lazycatcloud/lzc-cli/-/lzc-cli-2.0.9.tgz"
  sha256 "78ae56ee70992b64a57718b14e22594934db2500d42e35c1998db47970636ad2"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any, arm64_tahoe:  "25ad3ad6132ddf587345e7204803e50f023d475adfc581d48be804795d9b3da9"
    sha256 cellar: :any, arm64_linux:  "b332e4dfdf108e8f948b0803e08411056f2c75a34e33d9588876e722267810b6"
    sha256 cellar: :any, x86_64_linux: "c3321ff798adc9a58834267f7330ff9c791ed6b27b7f879624967d52fa2a2245"
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
