class OpenlibertyWebprofile8 < Formula
  desc "Implementation of Jakarta EE Web Profile 8"
  homepage "https://openliberty.io"
  url "https://public.dhe.ibm.com/ibmdl/export/pub/software/openliberty/runtime/release/2021-05-10_1231/openliberty-webProfile8-21.0.0.5.zip"
  sha256 "edc8deb3862890f6ea3b4d495fad165bcead784099c3968f8d7c56402cb49bea"
  license "EPL-1.0"

  livecheck do
    url "https://openliberty.io/api/builds/data"
    regex(/openliberty-webProfile8[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle :unneeded

  depends_on "openjdk"

  def install
    rm_rf Dir["bin/**/*.bat"]

    prefix.install %w[LICENSE NOTICES README.TXT]
    libexec.install Dir["*"]
  end

  test do
    system libexec/"bin/server", "version"
  end
end
