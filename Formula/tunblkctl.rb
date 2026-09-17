class Tunblkctl < Formula
  desc "Command-line frontend for Tunnelblick"
  homepage "https://github.com/azhuchkov/tunblkctl"
  url "https://github.com/azhuchkov/tunblkctl/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "875f639c4ad883ee93dbe46442a289b81f5178f9d6eb2a0ef8fe92d9e8cb9394"
  license "MIT"
  head "https://github.com/azhuchkov/tunblkctl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "19e360802d4f52fbfb7abd047be384372cb31cc90ea9e53a396a9f6a74fd0c0d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7896327f24e0765052f06359c48a3a7cbfb030b6a7452296fdac413579bb4146"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e798c663f09297f4f2a8fcc2bb86f22ec53c9dfe1d49815f41d66b5cae449610"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "88afc717e9ef44dccff914144c1c8e34cdfdc70093ab8820dc40b190bc14eab7"
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
