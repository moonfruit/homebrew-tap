class Goimports < Formula
  desc "Go Tool for updating import lines"
  homepage "https://golang.org/x/tools"
  url "https://github.com/golang/tools/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "c1e93ac3be804264bbe3779418caa6728944472cf5bc9368365657e31c1b4a2e"
  license "BSD-3-Clause"

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/goimports"
  end

  test do
    assert_empty pipe_output(bin/"goimports", "", 0)
  end
end
