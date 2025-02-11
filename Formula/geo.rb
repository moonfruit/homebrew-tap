class Geo < Formula
  desc "Manager for geo resources"
  homepage "https://github.com/MetaCubeX/geo"
  url "https://github.com/MetaCubeX/geo/archive/refs/tags/v1.1.tar.gz"
  sha256 "5429d31a1076918d868d7ff6d18a83bd4abe89e766c1ffeea048b47c4026f122"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/MetaCubeX/geo.git"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50d3698057d523fba2fe48bf40d3d4306cc8ac5cc3088dda48bdb1c560c03db6"
    sha256 cellar: :any_skip_relocation, ventura:       "9085ba2b7f7bc744472fcf57e9447ffd8923ce97e175d6dcc99f14e8bf77645f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce128bf6501a2bb7c7e1555fb6d3e4e1c72e82f0f31a6196dea57fab91752f74"
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
