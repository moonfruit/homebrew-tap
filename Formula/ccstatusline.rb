class Ccstatusline < Formula
  desc "Status line formatter for Claude Code"
  homepage "https://github.com/sirmalloc/ccstatusline"
  url "https://registry.npmjs.org/ccstatusline/-/ccstatusline-2.2.10.tgz"
  sha256 "8cbacdb97422938a38a02f64325d75903245ba6d15c2e50f697c7e87a204dfdf"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "64cb94b1aca4c037da3cb5cf504d08c19642788ae88296bd143f17fc9660b588"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4aebbda07d9eaefd171d3aa04f17745c03bdc15924684b6c14e2d1c81c916dce"
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
