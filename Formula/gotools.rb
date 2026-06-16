class Gotools < Formula
  desc "Monorepo of small Go command-line utilities"
  homepage "https://github.com/moonfruit/gotools"
  url "https://github.com/moonfruit/gotools/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "6c4a27c089b61ea4cf10661887f1d5d9aa7c282bd63809a8d1d574e0d6c607a6"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "821bd0c5116d9c62d88b6ec4ce88d3e32ec119874ae0af0f6ff6749f3b2ae839"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "9257d3fda37c89ed08df0a0979016cc6391934aa192e48c1c6b2d6e4ee06980f"
    sha256 cellar: :any,                 x86_64_linux: "85305ec016a67a93bd0a73ba64de624dca192b46c4d92f4f8209bb5e946d1457"
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
