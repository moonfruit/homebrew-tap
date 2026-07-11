class Ccstatusline < Formula
  desc "Status line formatter for Claude Code"
  homepage "https://github.com/sirmalloc/ccstatusline"
  url "https://registry.npmjs.org/ccstatusline/-/ccstatusline-2.2.23.tgz"
  sha256 "696fb5d5f83c8f5a1ca799d29b0a1c4dc4a48edde7b49be395a4a1f3b8b73e25"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "3e6b21eae110d981a9ddb94fdbf63ad019db4bc83357d494e1f10866bf2d4536"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "ef9dcab2bbf60ff8ed9fe04005d91001ed9ae8d24df7c750b7acd655cfb9d36a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c2250a164e2fcd8f2aea320f5cdf0abe6c464092da1d33a5f7485d8c45a42d1a"
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
