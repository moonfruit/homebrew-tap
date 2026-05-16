class Ccstatusline < Formula
  desc "Status line formatter for Claude Code"
  homepage "https://github.com/sirmalloc/ccstatusline"
  url "https://registry.npmjs.org/ccstatusline/-/ccstatusline-2.2.18.tgz"
  sha256 "9d12a73b54503c38e1d8729e4cd5f5ed69d36e98ddfd077a73a427baecfd6f07"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "93a27e37cbd60db78215818f0e6e126ab798fc046b9ae12901107c321f7bea42"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "6c4ffdc4af3c76e9b18070b642ff6adfde790da6657f4e510a1f43ebb2e63521"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "890e970700e5dbb4675c1fa64cfdf6848b37c6ef4824c19118bc27b5fc94c71f"
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
