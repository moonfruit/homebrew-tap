class WlpWebprofile8 < Formula
  desc "Implementation of Jakarta EE Web Profile 8"
  homepage "https://www.ibm.com/cloud/websphere-liberty"
  url "https://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/wasdev/downloads/wlp/21.0.0.3/wlp-webProfile8-21.0.0.3.zip"
  sha256 "a1aeb4e6554f53a181a1d35b8389626d89505dec3abf698fd1bdd77067ef6dff"

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
