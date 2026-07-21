class Ccstatusline < Formula
  desc "Status line formatter for Claude Code"
  homepage "https://github.com/sirmalloc/ccstatusline"
  url "https://registry.npmjs.org/ccstatusline/-/ccstatusline-2.2.25.tgz"
  sha256 "83850d8591e909e4ded6293b4f9d20663b3103ed7fe4f01b171ba8dcf7bf3c94"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "5876d1388ab937a13686eb44ab4e025279f2f6515747d09b3ad0566968a2fdfe"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "f792bdd8b24c665a7e5501c1c3fa8ca2e846bba71d8adde0466caf7654368390"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "cedc58a4b85cffa661d4636d39dd481705b27f2a61c377380cdaa6bfd5bb6380"
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
