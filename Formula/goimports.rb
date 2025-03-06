class Goimports < Formula
  desc "Go Tool for updating import lines"
  homepage "https://golang.org/x/tools"
  url "https://github.com/golang/tools/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "e5d74f1e63a1ee669e75e76668cea1b110e2b9d19c67710f60939ee38070a5a7"
  license "BSD-3-Clause"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "513d9b7c43227b9c3801696aeb50ac82e6e911caa713650cf0a48596f0b6b6ce"
    sha256 cellar: :any_skip_relocation, ventura:       "fe9e986045de7f20fb1b1f266f2d3c04ac0e4a15371f53a0aa3b48a62634ae6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8a5a226a2751756d95a649aab5f9330bae9c22dc530d61fbf42047239be0cce"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/goimports"
  end

  test do
    assert_empty pipe_output(bin/"goimports", "", 0)
  end
end
