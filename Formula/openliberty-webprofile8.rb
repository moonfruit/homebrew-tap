class OpenlibertyWebprofile8 < Formula
  desc "Implementation of Jakarta EE Web Profile 8"
  homepage "https://openliberty.io"
  url "https://public.dhe.ibm.com/ibmdl/export/pub/software/openliberty/runtime/release/2021-06-29_1900/openliberty-webProfile8-21.0.0.7.zip"
  sha256 "81ca14590f345457a9d5415acff3af59d7ae8d1b551c24256031f0b85f0da185"
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
