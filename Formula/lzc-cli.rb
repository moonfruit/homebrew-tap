class LzcCli < Formula
  desc "Client for Lazycat hardware"
  homepage "https://www.npmjs.com/package/@lazycatcloud/lzc-cli"
  url "https://registry.npmjs.org/@lazycatcloud/lzc-cli/-/lzc-cli-2.0.8.tgz"
  sha256 "b62865a28ae645745bd4b009cf6fde2820106f4c520b437d67c925fe88dd56de"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any,                 arm64_tahoe:  "64b405a5fff5be1059b2cbe6e9e104f8abd41cd10723af9771d0be1e729f147f"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "6aa9c1ce618986e0dfed3ea81d950ae8e15c2de15639b23f4c5135ccfe3f5e41"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "97f6f7cf2c37875ad6b9a328b5086472bc44a150ea41c0e1588ab99f19fbd84d"
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
