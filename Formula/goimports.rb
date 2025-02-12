class Goimports < Formula
  desc "Go Tool for updating import lines"
  homepage "https://golang.org/x/tools"
  url "https://github.com/golang/tools/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "c1e93ac3be804264bbe3779418caa6728944472cf5bc9368365657e31c1b4a2e"
  license "BSD-3-Clause"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83f929f42c693c98667be95e33fef703700164f4da619e0d22ef2c8f3e9caa5f"
    sha256 cellar: :any_skip_relocation, ventura:       "b679543b6c76ff3edfe5b0c1ab1c9244915acd38e74ef2b79a96bb0f80f3c5b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f273798e6206328a3907e46694b0597f50351bc8c32ea6b47c6ac1e0e662d0e"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/goimports"
  end

  test do
    assert_empty pipe_output(bin/"goimports", "", 0)
  end
end
