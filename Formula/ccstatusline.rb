class Ccstatusline < Formula
  desc "Status line formatter for Claude Code"
  homepage "https://github.com/sirmalloc/ccstatusline"
  url "https://registry.npmjs.org/ccstatusline/-/ccstatusline-2.2.28.tgz"
  sha256 "089c7db133ef0c50f02acce90c1be418efd16d66746e716dd95913551c58d5d2"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "5bf0e9343bbf39c3453fd9409b4dcc43d6c7c04c8ad41c6f34ed116ca7584a92"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "1223d4bafddd3d6eec4ac5202f9ce69f53f94299a517df97fbe8335061bfae9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e88558c1dd5ed1baac1a0a0ec5fd65c5329c92447acdb4cf2ad80066e3234cff"
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
