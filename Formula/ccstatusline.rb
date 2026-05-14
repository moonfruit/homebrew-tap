class Ccstatusline < Formula
  desc "Status line formatter for Claude Code"
  homepage "https://github.com/sirmalloc/ccstatusline"
  url "https://registry.npmjs.org/ccstatusline/-/ccstatusline-2.2.16.tgz"
  sha256 "ad81330bcf9e2522fd7c34555376cc3ad75a3523df8299aa6f3916dfdaf6bf2d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "dab3d0743b85d304197916fb7ade3542a524c3957cd7819f97eefca836639faa"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "3a33dab6f36cde349f4e8039b9938699e32e7ec301d084016cb50b860a6e0662"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "820a83560a1d9bce6c57a7db9cb6b72341b7532a57e4dd5a509fd665f57a448b"
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
