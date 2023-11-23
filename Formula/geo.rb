class Geo < Formula
  desc "Manager for geo resources"
  homepage "https://github.com/MetaCubeX/geo"
  url "https://github.com/MetaCubeX/geo/archive/refs/tags/latest.tar.gz"
  version "latest"
  sha256 "a0ff1ae6961188a684b2809f87d3e3ac42efd504ae98bf1cde1e93a6bd868867"
  license "GPL-3.0-only"
  head "https://github.com/MetaCubeX/geo.git"

  livecheck do
    skip "Not released, use head only"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/geo"
    generate_completions_from_executable(bin/"geo", "completion")
  end

  test do
    system "#{bin}/geo", "--help"
  end
end
