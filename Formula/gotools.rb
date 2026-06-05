class Gotools < Formula
  desc "Monorepo of small Go command-line utilities"
  homepage "https://github.com/moonfruit/gotools"
  url "https://github.com/moonfruit/gotools/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "02229236df64c7a95875a8a770af3f09cd98b58ca7b1e77255461c3136ac206d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "05988c2eb5946b4940b732ef0544f4b4970400f5e19ac12f8cab45a03028ae55"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "123285852c3d1b838b4b48b07bf26baa4403a5e376970550d9aa6ed63e81618f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e2ded20feb16bada77ebe13e30d86d2b2166045e55b5451f2764cfe491aed850"
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
