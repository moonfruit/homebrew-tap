class Ccstatusline < Formula
  desc "Status line formatter for Claude Code"
  homepage "https://github.com/sirmalloc/ccstatusline"
  url "https://registry.npmjs.org/ccstatusline/-/ccstatusline-2.2.20.tgz"
  sha256 "93bc3dcb9e1dabccbf581cd83207fd816d69e96acf69cc5397823652a2c5a165"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "eab23da4dc1441705f3090325384914fac4b99eaa1aeaba593eb5e44fa0168f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "cb8b46ed5416ebd3719a10e10e0c60c1d57c2baa462059293445ff2adc115376"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1d1774269a9d87a9c423998d54c903b40895c955c44e1930978511bcc08333fa"
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
