class Gotools < Formula
  desc "Monorepo of small Go command-line utilities"
  homepage "https://github.com/moonfruit/gotools"
  url "https://github.com/moonfruit/gotools/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "3d7ee23f1c7310bb341d45b529f7a1ed399b9b8d22cc6ea02889c94ecb123081"
  license "MIT"

  bottle do
    rebuild 1
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
