class Ccstatusline < Formula
  desc "Status line formatter for Claude Code"
  homepage "https://github.com/sirmalloc/ccstatusline"
  url "https://registry.npmjs.org/ccstatusline/-/ccstatusline-2.2.21.tgz"
  sha256 "9691033d205c387bccad3a487b0089c97c8c04f825885c51d565d5bec44b69d3"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "ffc41e8ece65f39e93a141599cf3090c1bc85378b2c01591f822ab98f61692b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "23c8705a904c1459ccc2d14ca819a17c7dbb5b9d73312c06bfe19ca0c5d97245"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f99acb8fdaa6c55f0a53774ef55f200b4565e141ab3b0a593cbaf06c9d028a7a"
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
