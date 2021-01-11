class WlpWebprofile8 < Formula
  desc "IBM WebSphere Liberty Web Profile 8"
  homepage "https://www.ibm.com/cloud/websphere-liberty"
  url "https://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/wasdev/downloads/wlp/20.0.0.12/wlp-webProfile8-20.0.0.12.zip"
  sha256 "c49069e1e33bc253ff69f507594156e3cd267492ef8b9dfb24d2a975c78a900c"

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
