class Ccstatusline < Formula
  desc "Status line formatter for Claude Code"
  homepage "https://github.com/sirmalloc/ccstatusline"
  url "https://registry.npmjs.org/ccstatusline/-/ccstatusline-2.2.29.tgz"
  sha256 "dc580be15d04378711f2e15f0d7678ce14aa0dcb7b20e557a89b0d942a0679e5"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e54b8efdf3c970e98459e7cca7e2b99d82e60e678becffbaf0a29256bb9c98d4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "eda2a77f81a9e929d88f8ec5175b9cc9972f0c4a382091ce8976fc6b4e601356"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9b87a23f622a1ee26d15c04392eaa52fc4ffd7ec1164ad55214554367b562515"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "344960f32c52550a9770fec00c69bcb9ef9054bbfb7ec9864d6267e59b0badf8"
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
