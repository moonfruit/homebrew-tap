class Geo < Formula
  desc "Manager for geo resources"
  homepage "https://github.com/MetaCubeX/geo"
  url "https://github.com/MetaCubeX/geo/archive/refs/tags/v1.1.tar.gz"
  sha256 "5429d31a1076918d868d7ff6d18a83bd4abe89e766c1ffeea048b47c4026f122"
  license "GPL-3.0-only"
  head "https://github.com/MetaCubeX/geo.git"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/geo"
    generate_completions_from_executable(bin/"geo", "completion")
  end

  test do
    system "#{bin}/geo", "--help"
  end
end
