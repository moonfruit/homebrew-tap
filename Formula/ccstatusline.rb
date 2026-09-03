class Ccstatusline < Formula
  desc "Status line formatter for Claude Code"
  homepage "https://github.com/sirmalloc/ccstatusline"
  url "https://registry.npmjs.org/ccstatusline/-/ccstatusline-2.2.28.tgz"
  sha256 "089c7db133ef0c50f02acce90c1be418efd16d66746e716dd95913551c58d5d2"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "5c4f778386dd4d1ab486bd434f69123e76e598d8761a934fe2f988ca1e47b30d"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "d192cf359218950b8e2aaeba33b26610c08de1a51cf70740c3c9a667983fa5a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "10576220f9f96e1d22210f4465f8c6e799e34d38fa269ece2488adae7c5b071d"
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
