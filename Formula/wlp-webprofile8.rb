class WlpWebprofile8 < Formula
  desc "Jakarta EE and MicroProfile application server (Jakarta EE Web Profile 8)"
  homepage "https://www.ibm.com/cloud/websphere-liberty"
  url "https://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/wasdev/downloads/wlp/21.0.0.8/wlp-webProfile8-21.0.0.8.zip"
  sha256 "fedc223a8d18cd4287b6215c5cc9a2f5a42d7ee029142e1fc93d2397f57bb96e"

  livecheck do
    url "https://www.ibm.com/support/pages/websphere-liberty-developers"
    regex(/wlp-webProfile8[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle :unneeded

  depends_on "openjdk"

  def install
    rm_rf Dir["bin/**/*.bat"]

    prefix.install_metafiles
    libexec.install Dir["*"]
    (bin/"wlp-webprofile8").write_env_script "#{libexec}/bin/server",
                                             Language::Java.overridable_java_home_env
  end

  def caveats
    <<~EOS
      The home of Websphere Liberty Jakarta EE Web Profile 8 is:
        #{opt_libexec}
    EOS
  end

  test do
    ENV["WLP_USER_DIR"] = testpath

    begin
      system bin/"wlp-webprofile8", "start"
      assert_predicate testpath/"servers/.pid/defaultServer.pid", :exist?
    ensure
      system bin/"wlp-webprofile8", "stop"
    end

    refute_predicate testpath/"servers/.pid/defaultServer.pid", :exist?
    assert_match "<feature>webProfile-8.0</feature>", (testpath/"servers/defaultServer/server.xml").read
  end
end
