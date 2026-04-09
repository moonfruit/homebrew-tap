class Ccstatusline < Formula
  desc "Status line formatter for Claude Code"
  homepage "https://github.com/sirmalloc/ccstatusline"
  url "https://registry.npmjs.org/ccstatusline/-/ccstatusline-2.2.8.tgz"
  sha256 "e3e7d9f320e52b08be98920c1c490f832b7cbc0d2437715c6849946d753b72dc"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "173e5f191a231970f29838267631f466b6166e0c3c028993916d4c08088fd069"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0cf3f9c990a0653673ace7fdcb06c8b2ab6697dc1d72c0a58cc41d12aa210f41"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    input = <<~JSON
      {"model":{"display_name":"TestModel"},"workspace":{"current_dir":"#{testpath}"}}
    JSON
    assert_match "TestModel", pipe_output(bin/"ccstatusline", input, 0)
  end
end
