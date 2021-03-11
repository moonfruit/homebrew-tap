class OpenlibertyWebprofile8 < Formula
  desc "Open Liberty Web Profile 8"
  homepage "https://openliberty.io"
  url "https://public.dhe.ibm.com/ibmdl/export/pub/software/openliberty/runtime/release/2021-02-09_1100/openliberty-webProfile8-21.0.0.2.zip"
  sha256 "e799d003f0b30d197a3ff165b16bbfe5d8ff64f9f069b50663e4260dee3a95c8"
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
