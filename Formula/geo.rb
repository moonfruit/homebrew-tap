class Geo < Formula
  desc "Manager for geo resources"
  homepage "https://github.com/MetaCubeX/geo"
  url "https://github.com/MetaCubeX/geo/archive/refs/tags/v1.1.tar.gz"
  sha256 "5429d31a1076918d868d7ff6d18a83bd4abe89e766c1ffeea048b47c4026f122"
  license "GPL-3.0-only"
  revision 2
  head "https://github.com/MetaCubeX/geo.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "e63ee807f38e1c3ab3033e5404fd0336750f3cdaeb0b60b6b4ca4a919570d4bd"
    sha256 cellar: :any_skip_relocation, ventura:      "5b7d1148942e9d9de332e3e3ecb324c60f45e78f5eb0662df6ed70ee7c89f2c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ee57a8204d3b43391b3bd99b338fd4f6710d8f6f68cf17230f5236cbe2f02ad6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/geo"
    generate_completions_from_executable(bin/"geo", "completion")
  end

  test do
    system bin/"geo", "--help"
  end
end
