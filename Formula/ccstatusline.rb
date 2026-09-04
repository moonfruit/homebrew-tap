class Ccstatusline < Formula
  desc "Status line formatter for Claude Code"
  homepage "https://github.com/sirmalloc/ccstatusline"
  url "https://registry.npmjs.org/ccstatusline/-/ccstatusline-2.2.29.tgz"
  sha256 "dc580be15d04378711f2e15f0d7678ce14aa0dcb7b20e557a89b0d942a0679e5"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "2e62b2f8ce22c6f0fd61b620d7ce7a689a44d9ef7dbf257371dbdd6582b8dbd1"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "bc1659e3948d922a9d032861d1f70894df93c00dbe125c24223e0491654a9ae5"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "13605e7e07ec1a3a3fed2d2c8d6acf433693532b215040e45e76e45302743481"
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
