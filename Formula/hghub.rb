class Hghub < Formula
  desc "Third-party YellowFruit short drama client"
  homepage "https://github.com/Minireel/HGhub"
  url "https://github.com/Minireel/HGhub/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "a1ef316780a4ff143308a70e47626d998b66b2b77f7a4a2c6026252a29b67596"
  license "PolyForm-Noncommercial-1.0.0"

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
