require "formula_installer"

FormulaInstaller.class_eval do
  define_method(:fix_dynamic_linkage) do |_keg|
    nil
  end
end

class OracleInstantclient < Formula
  desc "Instant Client for Oracle"
  homepage "https://www.oracle.com/database/technologies/instant-client.html"
  url "https://download.oracle.com/otn_software/mac/instantclient/2326100/instantclient-basic-macos.arm64-23.26.1.0.0.dmg"
  sha256 "5dc67a7e1cccd0a01d5bf53d7cf13b56f00999e3c2c1a309d8600cd766d80b41"
  license :cannot_represent

  livecheck do
    url "https://www.oracle.com/database/technologies/instant-client/macos-arm64-downloads.html"
    regex(/href=.*instantclient-\w*-macos.arm64[._-]v?(\d+(?:\.\d+)+(?:-\d+)?).dmg/i)
  end

  depends_on arch: :arm64
  depends_on :macos

  resource "sqlplus" do
    url "https://download.oracle.com/otn_software/mac/instantclient/2326100/instantclient-sqlplus-macos.arm64-23.26.1.0.0.dmg"
    sha256 "db973a9d2a672b462333feda091c8b2e2defe7aa2a2f4b266a8f36ee356d979e"
  end

  resource "sdk" do
    url "https://download.oracle.com/otn_software/mac/instantclient/2326100/instantclient-sdk-macos.arm64-23.26.1.0.0.dmg"
    sha256 "6a101a8c6651a76055a3222b1860dcdabdc7c14c82759daa8ca11c5d13c8d1eb"
  end

  resource "precompiler" do
    url "https://download.oracle.com/otn_software/mac/instantclient/2326100/instantclient-precomp-macos.arm64-23.26.1.0.0.dmg"
    sha256 "d5fc90ffa7e36e55a97154737debabf618cb3fe7f90f4f0e909e538afe3721ea"
  end

  def install
    dir = "instantclient_#{version.major}_#{version.minor}"
    excluded = %w[INSTALL_IC_README.txt install_ic.sh]

    cd dir do
      pkgetc.install "network"
      libexec.install Dir["*"] - [*excluded, "network"]
      libexec.install_symlink pkgetc/"network"
    end

    resource("sqlplus").stage do
      cd dir do
        libexec.install Dir["*"] - excluded
      end
    end

    resource("sdk").stage do
      cd dir do
        libexec.install Dir["*"] - excluded
      end
    end

    resource("precompiler").stage do
      cd dir do
        pkgetc.install "precomp"
        libexec.install Dir["*"] - [*excluded, "sdk", "precomp"]
        libexec.install_symlink pkgetc/"precomp"
        (libexec/"sdk").install "sdk/proc"
        (libexec/"sdk/demo").install Dir["sdk/demo/*"]
        (libexec/"sdk/include").install Dir["sdk/include/*"]
      end
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
