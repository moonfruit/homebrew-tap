class OracleInstantclient < Formula
  desc "Instant Client for Oracle"
  homepage "https://www.oracle.com/database/technologies/instant-client.html"
  url "https://download.oracle.com/otn_software/mac/instantclient/2326300/instantclient-basic-macos.arm64-23.26.3.0.0.dmg", using: :nounzip
  sha256 "9ad4824c5dca702e6bb68d459e2cd738e6ee1e750c668e54a09a43fee9f5d08a"
  license :cannot_represent

  livecheck do
    url "https://www.oracle.com/database/technologies/instant-client/macos-arm64-downloads.html"
    regex(/href=.*instantclient-\w*-macos.arm64[._-]v?(\d+(?:\.\d+)+(?:-\d+)?).dmg/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, all: "7d44183d5069c38d0de6cdc1ba5855a69edc1802605acebc8e9dda6462694009"
  end

  depends_on "sevenzip" => :build
  depends_on arch: :arm64
  depends_on :macos

  # The shipped binaries are signed by Oracle and load each other through
  # `@rpath`. Rewriting the dylib IDs would force an ad-hoc re-signature, and
  # dyld then refuses to map them into the untouched, Oracle-signed executables
  # ("mapping process and mapped file (non-platform) have different Team IDs").
  preserve_rpath

  resource "sqlplus" do
    url "https://download.oracle.com/otn_software/mac/instantclient/2326300/instantclient-sqlplus-macos.arm64-23.26.3.0.0.dmg", using: :nounzip
    sha256 "332d6b73e213cd4652888430368f3ba258b03a7f1ec6837c13d0f6c3637fbe68"
  end

  resource "sdk" do
    url "https://download.oracle.com/otn_software/mac/instantclient/2326300/instantclient-sdk-macos.arm64-23.26.3.0.0.dmg", using: :nounzip
    sha256 "e61b71c32ca51a3546a480bd25f9f7ecdae66ac56abec4004c70246cc451d71f"
  end

  resource "precompiler" do
    url "https://download.oracle.com/otn_software/mac/instantclient/2326300/instantclient-precomp-macos.arm64-23.26.3.0.0.dmg", using: :nounzip
    sha256 "d583fde11f67f3f6e5ca21c83470d0ac06657a5205ff564c907a422f58650d09"
  end

  def install
    excluded = %w[INSTALL_IC_README.txt install_ic.sh]

    extract_dmg

    pkgetc.install "network"
    libexec.install Dir["*"] - [*excluded, "network"]
    libexec.install_symlink pkgetc/"network"

    resource("sqlplus").stage do
      extract_dmg
      libexec.install Dir["*"] - excluded
    end

    resource("sdk").stage do
      extract_dmg
      libexec.install Dir["*"] - excluded
    end

    resource("precompiler").stage do
      extract_dmg
      pkgetc.install "precomp"
      libexec.install Dir["*"] - [*excluded, "sdk", "precomp"]
      libexec.install_symlink pkgetc/"precomp"
      (libexec/"sdk").install "sdk/proc"
      (libexec/"sdk/demo").install Dir["sdk/demo/*"]
      (libexec/"sdk/include").install Dir["sdk/include/*"]
    end

    env = {
      ORACLE_HOME: "${ORACLE_HOME:-#{opt_libexec}}",
      NLS_LANG:    "${NLS_LANG:-SIMPLIFIED CHINESE_CHINA.AL32UTF8}",
    }
    (bin/"sqlplus").write_env_script opt_libexec/"sqlplus", env
    (bin/"proc").write_env_script opt_libexec/"sdk/proc", env
  end

  def extract_dmg
    # `hdiutil` cannot attach disk images inside the macOS build sandbox, which
    # denies the Mach services it needs, so extract them with 7-Zip instead.
    Dir["*.dmg"].each do |dmg|
      system formula_opt_bin("sevenzip")/"7zz", "x", dmg
      rm dmg
    end
    # Match Homebrew's DMG unpacking, which makes the read-only image contents
    # writable so later installs can overwrite files such as those in `etc`.
    chmod "u+w", Pathname.glob("**/*", File::FNM_DOTMATCH).reject(&:symlink?)
  end

  test do
    assert_match "Version #{version.major_minor_patch}", shell_output("#{bin}/sqlplus -V")
  end
end
