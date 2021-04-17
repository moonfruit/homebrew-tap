class OpenlibertyWebprofile8 < Formula
  desc "Implementation of Jakarta EE Web Profile 8"
  homepage "https://openliberty.io"
  url "https://public.dhe.ibm.com/ibmdl/export/pub/software/openliberty/runtime/release/2021-04-07_0944/openliberty-webProfile8-21.0.0.4.zip"
  sha256 "ad6c69370a184438aba2863a60883252f5e8a676095936be8e73b63b5820ea42"
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
