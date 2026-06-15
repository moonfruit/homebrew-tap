class Ccstatusline < Formula
  desc "Status line formatter for Claude Code"
  homepage "https://github.com/sirmalloc/ccstatusline"
  url "https://registry.npmjs.org/ccstatusline/-/ccstatusline-2.2.20.tgz"
  sha256 "93bc3dcb9e1dabccbf581cd83207fd816d69e96acf69cc5397823652a2c5a165"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "d0866983082d417825ee05a8671261ace539fe7915f9a19f481c85f3a73b6795"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "4c5da80821fb129dd0517cf54a4069d4c862b35aaa20f0b5b630447b0cfe43c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a1ed038695e06ec5448371e43bbe411dda11734bc5ee0ab941b86e30f3c0b89e"
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
