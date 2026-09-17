class Gotools < Formula
  desc "Monorepo of small Go command-line utilities"
  homepage "https://github.com/moonfruit/gotools"
  url "https://github.com/moonfruit/gotools/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "3d7ee23f1c7310bb341d45b529f7a1ed399b9b8d22cc6ea02889c94ecb123081"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f1d851fa44df46af99bfef184bed7475a5f2a91fc875354428e7819e54c435d1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b96a994f21e76d492788f4dd1d866ece92e5abd1dcd6703798f2d5e189ac8009"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f5eb03dbc01cb795bb9a2123134c4c672c7a9ba64959b904ec03b0d4903409d8"
    sha256 cellar: :any,                 x86_64_linux:      "4d1917b561de431f0d9b61b291c505379df5996eb3956d5152d5b1b3e77a8910"
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
