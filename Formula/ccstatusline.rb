class Ccstatusline < Formula
  desc "Status line formatter for Claude Code"
  homepage "https://github.com/sirmalloc/ccstatusline"
  url "https://registry.npmjs.org/ccstatusline/-/ccstatusline-2.2.17.tgz"
  sha256 "f167c2b8fc841e52549d07c0021ba7dbd1a5a49bc0d2c49a4d792f6d2fcdaa22"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "6c7c13aa99e8fac22aa029b48d82e4a7ca76bf9e5c623787891bf925e76a6d82"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "4841e76b6213dd910fe929b0a7b7358e9c875a7ab84aabd6401d649998c1e6dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1eec4532c10ba43cad5599a7bd8a8728557589e61d477f50fecdcbfceef50123"
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
