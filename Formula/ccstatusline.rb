class Ccstatusline < Formula
  desc "Status line formatter for Claude Code"
  homepage "https://github.com/sirmalloc/ccstatusline"
  url "https://registry.npmjs.org/ccstatusline/-/ccstatusline-2.2.33.tgz"
  sha256 "a9c7b178f73aa1ac1ee5c49543fb3765e04dac774fd257654c00e60a92adc174"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, all: "30da60c21d86d0656d7a095c43d570fd51e0c133d93231f4d809c6295b4f4665"
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
