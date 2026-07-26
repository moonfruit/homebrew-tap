class Ccstatusline < Formula
  desc "Status line formatter for Claude Code"
  homepage "https://github.com/sirmalloc/ccstatusline"
  url "https://registry.npmjs.org/ccstatusline/-/ccstatusline-2.2.27.tgz"
  sha256 "4f609bded10d8c1064516cefb902ed59391ab2bbba97d593e8a12d07e2da58c2"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "0c6fa36f3eabf061a9a5a723fbcac64ce097699742539ebe0f25dbe0693e8567"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "8d42f5ca6424bacb340d95a75070b5620aa8ab1b3116ef623801cccd15b879b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7790d8298586f714c08d7b3cc06a98bdb20ddf0fe531c4c44b2111c4e3dda4bf"
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
