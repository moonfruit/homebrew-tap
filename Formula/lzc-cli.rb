class LzcCli < Formula
  desc "Client for Lazycat hardware"
  homepage "https://www.npmjs.com/package/@lazycatcloud/lzc-cli"
  url "https://registry.npmjs.org/@lazycatcloud/lzc-cli/-/lzc-cli-2.0.9.tgz"
  sha256 "78ae56ee70992b64a57718b14e22594934db2500d42e35c1998db47970636ad2"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    rebuild 2
    sha256 cellar: :any, arm64_golden_gate: "fcd806dcfb52a12b887dfe4e9a30ce9a84c34686fa5ad6e0e03ebe1fccd7eefc"
    sha256 cellar: :any, arm64_tahoe:       "fcd806dcfb52a12b887dfe4e9a30ce9a84c34686fa5ad6e0e03ebe1fccd7eefc"
    sha256 cellar: :any, arm64_linux:       "bf927c5286838c9972cd758c59ea489f8864148c6e042ad74ff85410d36caed4"
    sha256 cellar: :any, x86_64_linux:      "b497e1449204294a368a208680bba8885db40b90573828ae6ff04cc5615b8c3a"
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
