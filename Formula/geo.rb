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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "299989d969be58bdaec56ff4c6dcd8fdda56d95cd233623835cf8ffae1daf296"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b65ffa85d5cdb5520720b2371954d75475cb94e4b8aaf7c248cf251e2b40f11f"
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
