require "formula_installer"

FormulaInstaller.class_eval do
  def fix_dynamic_linkage(keg); end
end

class OracleInstantclient < Formula
  desc "Instant Client for Oracle"
  homepage "https://www.oracle.com/database/technologies/instant-client.html"
  url "https://download.oracle.com/otn_software/mac/instantclient/233023/instantclient-basic-macos.arm64-23.3.0.23.09-1.dmg"
  sha256 "1bcddb583870f70c232d579edb8a32fd58497028a4eff1ad28ece0397ba8d7fe"
  license :cannot_represent

  livecheck do
    url "https://www.oracle.com/database/technologies/instant-client/macos-arm64-downloads.html"
    regex(/href=.*instantclient-\w*-macos.arm64[._-]v?(\d+(?:\.\d+)+(?:-\d+)?).dmg/i)
  end

  depends_on arch: :arm64
  depends_on :macos

  resource "sqlplus" do
    url "https://download.oracle.com/otn_software/mac/instantclient/233023/instantclient-sqlplus-macos.arm64-23.3.0.23.09.dmg"
    sha256 "9213a399a13101bdebcd613027fa385ef44c42bba2330f9480b16db0e1a7d676"
  end

  resource "sdk" do
    url "https://download.oracle.com/otn_software/mac/instantclient/233023/instantclient-sdk-macos.arm64-23.3.0.23.09.dmg"
    sha256 "3deadfce089eb6b9c091b1fd213ed7a66685bb22643c7c74be5e050ad8cfccbb"
  end

  resource "precompiler" do
    url "https://download.oracle.com/otn_software/mac/instantclient/233023/instantclient-precomp-macos.arm64-23.3.0.23.09.dmg"
    sha256 "d5b4a91507bf792535e990df02b104560053044505f2c82f229aab7686c944d8"
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
      ORACLE_HOME: "${ORACCLE_HOME:-#{opt_libexec}}",
      NLS_LANG:    "${NLS_LANG:-SIMPLIFIED CHINESE_CHINA.AL32UTF8}",
    }
    (bin/"sqlplus").write_env_script opt_libexec/"sqlplus", env
    (bin/"proc").write_env_script opt_libexec/"sdk/proc", env
  end

  test do
    assert_match "Version #{version.major_minor_patch}", shell_output("#{bin}/sqlplus -V")
  end
end
