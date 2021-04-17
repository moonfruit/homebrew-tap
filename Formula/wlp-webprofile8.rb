class WlpWebprofile8 < Formula
  desc "Implementation of Jakarta EE Web Profile 8"
  homepage "https://www.ibm.com/cloud/websphere-liberty"
  url "https://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/wasdev/downloads/wlp/21.0.0.4/wlp-webProfile8-21.0.0.4.zip"
  sha256 "7d1797ce813d50402c00c086a6924f8b8e440cf5ca4e896789dcd580b2957bdb"

  livecheck do
    url "https://www.ibm.com/support/pages/websphere-liberty-developers"
    regex(/wlp-webProfile8[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle :unneeded

  depends_on "openjdk"

  def install
    rm_rf Dir["bin/**/*.bat"]

    prefix.install %w[CHANGES.TXT Copyright.txt README.TXT]
    libexec.install Dir["*"]
  end

  test do
    system libexec/"bin/server", "version"
  end
end
