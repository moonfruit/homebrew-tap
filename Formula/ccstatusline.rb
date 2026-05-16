class Ccstatusline < Formula
  desc "Status line formatter for Claude Code"
  homepage "https://github.com/sirmalloc/ccstatusline"
  url "https://registry.npmjs.org/ccstatusline/-/ccstatusline-2.2.18.tgz"
  sha256 "9d12a73b54503c38e1d8729e4cd5f5ed69d36e98ddfd077a73a427baecfd6f07"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "0a6ce114f67cc5e4b0a2b69014232928fe1b71a0a61c9f8c8bb48a300fcae47e"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "4c28b34509ab078f31b47b09cf16b010390897aa97332f3e61f62e7fcc630744"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "42ddac19b4baea1c061c8523ef822dd18c166a11b16ae81b18b1ed366d2c393c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    libexec.glob("bin/*").each do |f|
      script_name = File.basename(f)
      (bin/script_name).write <<~BASH
        #!/usr/bin/env bash
        if command -v bun &>/dev/null; then
          exec bun run "#{libexec}/bin/#{script_name}" "$@"
        else
          exec "#{libexec}/bin/#{script_name}" "$@"
        fi
      BASH
    end
  end

  test do
    input = <<~JSON
      {"model":{"display_name":"TestModel"},"workspace":{"current_dir":"#{testpath}"}}
    JSON
    assert_match "TestModel", pipe_output(bin/"ccstatusline", input, 0)
  end
end
