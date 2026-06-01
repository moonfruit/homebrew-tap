class Tunblkctl < Formula
  desc "Command-line frontend for Tunnelblick"
  homepage "https://github.com/azhuchkov/tunblkctl"
  url "https://github.com/azhuchkov/tunblkctl/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "875f639c4ad883ee93dbe46442a289b81f5178f9d6eb2a0ef8fe92d9e8cb9394"
  license "MIT"
  head "https://github.com/azhuchkov/tunblkctl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "9d2c5c95c1b780b1970c2d760a85a650ad378a03c117e9123d3851a4a0bd4975"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "a01a84ad2ef67f7c9358ee0469d7b32eef37506727b6b079132f3ecc19523300"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0e3ac959a6f140e0a58d31dbc0715c1587ab447210e1e84ec038f28f698de5ae"
  end

  def install
    prefix.install "libexec"

    bin.install "bin/tunblkctl"

    bash_completion.install "completion/bash.sh" => "tunblkctl"
    zsh_completion.install "completion/zsh.sh" => "_tunblkctl"
    fish_completion.install "completion/fish.sh" => "tunblkctl.fish"

    man1.install "doc/man1/tunblkctl.1"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/tunblkctl 2>&1", 1)
  end
end
