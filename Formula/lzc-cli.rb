class LzcCli < Formula
  desc "Client for Lazycat hardware"
  homepage "https://www.npmjs.com/package/@lazycatcloud/lzc-cli"
  url "https://registry.npmjs.org/@lazycatcloud/lzc-cli/-/lzc-cli-2.0.3.tgz"
  sha256 "b5fc9162518a15f6537b5ce5d4eaedc8b8cdf6a496113b4784a96bf806c2b3c3"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any,                 arm64_tahoe:  "b2185a4430ed2cdc0989383608d7374620d3db5d31300bb4b3aa14d7819fd9d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3c9f29504c5a5cfa9d7b5cad4d2f19ac77b579e3f5c32ba41e7bf6908e3665bf"
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

    bin.install_symlink Dir["#{libexec}/bin/*"]

    generate_completions_from_executable(bin/"lzc-cli", "completion", shells: [:bash, :zsh])
  end

  test do
    assert_match "lzc-cli #{version}", shell_output("#{bin}/lzc-cli --version")
  end
end
