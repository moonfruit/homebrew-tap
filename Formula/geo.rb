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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "7df5070dda603a2ab7c5f00caf9805a77102b786dc9b390d4028250d2282a3b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4c1b5dd1abe1e7e39158e89bcc0cad23c2f6e3b4f145ce11d01bfa09198201a8"
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
