class Gotools < Formula
  desc "Monorepo of small Go command-line utilities"
  homepage "https://github.com/moonfruit/gotools"
  url "https://github.com/moonfruit/gotools/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "3d7ee23f1c7310bb341d45b529f7a1ed399b9b8d22cc6ea02889c94ecb123081"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "230e3545db00522cc3fef7a9a755ceca0ee6c14ab471572efbe6f17d7b188326"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "85610f9730d70d708e8271a7021b2ad52ce706fdbe157101589faaf3539a0b82"
    sha256 cellar: :any,                 x86_64_linux: "13efb65d2322798a42359621c08ed034273ace30d5505084abc89e121d740ec4"
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
