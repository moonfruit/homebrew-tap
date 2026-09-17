class Geo < Formula
  desc "Manager for geo resources"
  homepage "https://github.com/MetaCubeX/geo"
  url "https://github.com/MetaCubeX/geo/archive/refs/tags/v1.1.tar.gz"
  sha256 "5429d31a1076918d868d7ff6d18a83bd4abe89e766c1ffeea048b47c4026f122"
  license "GPL-3.0-only"
  revision 3
  head "https://github.com/MetaCubeX/geo.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "71e13e557b9826bb9b02a6dee9ea6ab7f413d65d38d017c9835d84d0289b16a3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bc07eb5e81bce708a321cf044400457a0577576f6480844a1d0890f97704e822"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d18561269a8f33c12744471acf507b1893a84654488c8c7b1f64a5b0ffcd8d0d"
    sha256 cellar: :any,                 x86_64_linux:      "0ac5abe73ffb6984c5574d3d96f344bfe8323e69102d7b7271e990df40f6c6e2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/geo"
    generate_completions_from_executable(bin/"geo", shell_parameter_format: :cobra)
  end

  test do
    system bin/"geo", "--help"
  end
end
