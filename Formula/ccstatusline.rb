class Ccstatusline < Formula
  desc "Status line formatter for Claude Code"
  homepage "https://github.com/sirmalloc/ccstatusline"
  url "https://registry.npmjs.org/ccstatusline/-/ccstatusline-2.2.25.tgz"
  sha256 "83850d8591e909e4ded6293b4f9d20663b3103ed7fe4f01b171ba8dcf7bf3c94"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "3a3095e7584bd8144aaba5500fd1093cca758e9631f5e482d54a3277136077d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "c3720c14b14dd3133644fc8ab69840b3477b25000237eaeb841b66154e85ea37"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c57d5f28a9eebd62a1740e6329eb34e44731d4db1b992181528a6f560629679f"
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
