class WlpWebprofile8 < Formula
  desc "IBM WebSphere Liberty Web Profile 8"
  homepage "https://www.ibm.com/cloud/websphere-liberty"
  url "https://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/wasdev/downloads/wlp/21.0.0.2/wlp-webProfile8-21.0.0.2.zip"
  sha256 "dc42a7a4af3af15edb103ae32a28d5e04e4f12e0df1b5b2edd92805f50a0ab6a"

  livecheck do
    url "https://www.ibm.com/support/pages/node/6250961#asset/runtimes-wlp-javaee8"
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
