class Hghub < Formula
  desc "Third-party YellowFruit short drama client"
  homepage "https://github.com/Minireel/HGhub"
  url "https://github.com/Minireel/HGhub/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "020c4ba3f9432ab1c0934d2f729172934efd2421c3130761d59de11f3a914de1"
  license "PolyForm-Noncommercial-1.0.0"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "70f8aefbf10912783003c14a48135ab22e6adf3730ea0e7329f4d3b07eca4931"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b1577601c3f2a8f4db13a25a41f1e173094fa7b08dc25d2c7510f4c85e0ad74f"
  end

  depends_on "node" => :build
  depends_on "pnpm" => :build
  depends_on "rust" => :build
  depends_on :macos

  # pnpm and Cargo download the dependencies pinned by the upstream lockfiles.
  allow_network_access! :build

  def install
    system "pnpm", "install", "--frozen-lockfile"
    system "pnpm", "app:build", "--bundles", "app", "--", "--locked"

    prefix.install "src-tauri/target/release/bundle/macos/HGhub.app"
    system "/usr/bin/codesign", "--force", "--sign", "-", prefix/"HGhub.app"
    bin.write_exec_script prefix/"HGhub.app/Contents/MacOS/huangguo-client"
    mv bin/"huangguo-client", bin/"hghub"
  end

  def caveats
    <<~EOS
      To make HGhub available in Launchpad, create a symlink:
        ln -s #{opt_prefix}/HGhub.app /Applications/HGhub.app
    EOS
  end

  test do
    app = prefix/"HGhub.app"
    plist = app/"Contents/Info.plist"
    assert_match version.to_s,
                 shell_output("/usr/bin/plutil -extract CFBundleShortVersionString raw #{plist}")
    assert_equal "com.hghub.huangguo",
                 shell_output("/usr/bin/plutil -extract CFBundleIdentifier raw #{plist}").strip
    assert_path_exists app/"Contents/MacOS/huangguo-client"
    system "/usr/bin/codesign", "--verify", "--strict", app
  end
end
