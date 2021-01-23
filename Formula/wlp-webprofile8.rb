class WlpWebprofile8 < Formula
  desc "IBM WebSphere Liberty Web Profile 8"
  homepage "https://www.ibm.com/cloud/websphere-liberty"
  url "https://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/wasdev/downloads/wlp/21.0.0.1/wlp-webProfile8-21.0.0.1.zip"
  sha256 "7754b7cca1375401b09961db7f72218b4d83fc6533bd445782c1b8a9e2d63880"

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
    system "server"
  end
end
