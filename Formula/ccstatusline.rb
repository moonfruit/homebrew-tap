class Ccstatusline < Formula
  desc "Status line formatter for Claude Code"
  homepage "https://github.com/sirmalloc/ccstatusline"
  url "https://registry.npmjs.org/ccstatusline/-/ccstatusline-2.2.22.tgz"
  sha256 "14a0c17a87088e23f8c57c4dc9c4c024596beecf88f339be80dbfd21c85cb100"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "4f16dccd6b8ec6a2c864e4b3a762ad383c40c401e4fbfbb14f250aa59bdff1cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "b629ebc287924b863f0d5cb4e6c9b53be6bf2c2157b63e2a68f923a9d3ae77ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8069d538ff19d9887b824245ddcc48ebcce6f0f6d294f46ef385f0bf69a9902a"
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
