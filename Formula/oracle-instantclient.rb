class OracleInstantclient < Formula
  desc "Instant Client for Oracle"
  homepage "https://www.oracle.com/database/technologies/instant-client.html"
  url "https://download.oracle.com/otn_software/mac/instantclient/2326200/instantclient-basic-macos.arm64-23.26.2.0.0.dmg"
  sha256 "c3c4fce37a557192322717c1a8422fe098fc829a41f382f57a288b24ad6ba11e"
  license :cannot_represent

  livecheck do
    url "https://www.oracle.com/database/technologies/instant-client/macos-arm64-downloads.html"
    regex(/href=.*instantclient-\w*-macos.arm64[._-]v?(\d+(?:\.\d+)+(?:-\d+)?).dmg/i)
  end

  depends_on arch: :arm64
  depends_on :macos

  # The shipped binaries are signed by Oracle and load each other through
  # `@rpath`. Rewriting the dylib IDs would force an ad-hoc re-signature, and
  # dyld then refuses to map them into the untouched, Oracle-signed executables
  # ("mapping process and mapped file (non-platform) have different Team IDs").
  preserve_rpath

  resource "sqlplus" do
    url "https://download.oracle.com/otn_software/mac/instantclient/2326200/instantclient-sqlplus-macos.arm64-23.26.2.0.0.dmg"
    sha256 "c3b10537194a5267a3ed18d09fddae1f864191e0de25ad78042940bb82496294"
  end

  resource "sdk" do
    url "https://download.oracle.com/otn_software/mac/instantclient/2326200/instantclient-sdk-macos.arm64-23.26.2.0.0.dmg"
    sha256 "5ee0dffe7ff0ac55eea198ef69681cc729fc7fdf17cc9089f8bfd5d93c51413e"
  end

  resource "precompiler" do
    url "https://download.oracle.com/otn_software/mac/instantclient/2326200/instantclient-precomp-macos.arm64-23.26.2.0.0.dmg"
    sha256 "aa32fe5ce1d4f1041bdfa73f00996c045d752718ea88be9428d54030cf52d349"
  end

  def install
    excluded = %w[INSTALL_IC_README.txt install_ic.sh]

    pkgetc.install "network"
    libexec.install Dir["*"] - [*excluded, "network"]
    libexec.install_symlink pkgetc/"network"

    resource("sqlplus").stage do
      libexec.install Dir["*"] - excluded
    end

    resource("sdk").stage do
      libexec.install Dir["*"] - excluded
    end

    resource("precompiler").stage do
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

  test do
    assert_match "Version #{version.major_minor_patch}", shell_output("#{bin}/sqlplus -V")
  end
end
