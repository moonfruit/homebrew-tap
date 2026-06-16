class Gotools < Formula
  desc "Monorepo of small Go command-line utilities"
  homepage "https://github.com/moonfruit/gotools"
  url "https://github.com/moonfruit/gotools/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "6c4a27c089b61ea4cf10661887f1d5d9aa7c282bd63809a8d1d574e0d6c607a6"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "77a7cc0dff91bbf00caa1ac67f96e107e91449c650af6357a19ec9de3db6005c"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "d63b83c115e1e3e4f775615b20b0921c0be5eddc80180dbc572eabdb94aeb84a"
    sha256 cellar: :any,                 x86_64_linux: "60dbade6b03f31b8ef8805e6206f12fc05e14030ed03615ac631fe71bd16af80"
  end

  depends_on "go" => :build

  def install
    Dir["cmd/*"].each do |dir|
      next unless File.directory?(dir)

      name = File.basename(dir)
      system "go", "build", *std_go_args(output: bin/name, ldflags: "-s -w"), "./#{dir}"
      generate_completions_from_executable(bin/name, shell_parameter_format: :cobra)
    end
  end

  test do
    input = "bob@example.com\nalice@1.1.1.1\nadmin@[::1]:22\n"
    expected = "alice@1.1.1.1\nadmin@[::1]:22\nbob@example.com\n"
    assert_equal expected, pipe_output(bin/"uhsort", input, 0)

    expected_count = "2\ta@h\n1\tb@h\n"
    assert_equal expected_count, pipe_output("#{bin}/uhsort -c", "a@h\na@h\nb@h\n", 0)
  end
end
