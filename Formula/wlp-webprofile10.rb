class WlpWebprofile10 < Formula
  desc "Jakarta EE and MicroProfile application server (Jakarta EE Web Profile 10)"
  homepage "https://www.ibm.com/cloud/websphere-liberty"
  url "https://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/wasdev/downloads/wlp/25.0.0.7/wlp-webProfile10-25.0.0.7.zip"
  sha256 "ffb0080c0ef1833f48f7d927d0124a3a78ca3aca39cdcdb4286bb4020d4dcff6"

  livecheck do
    url "https://www.ibm.com/support/pages/websphere-liberty-developers"
    regex(/wlp-webProfile10[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  depends_on "openjdk"

  def install
    rm Dir["bin/**/*.bat"]

    prefix.install_metafiles
    libexec.install Dir["*"]
    (bin/"wlp-webprofile10").write_env_script "#{libexec}/bin/server",
                                              Language::Java.overridable_java_home_env
  end

  def caveats
    <<~EOS
      The home of Websphere Liberty Jakarta EE Web Profile 10 is:
        #{opt_libexec}
    EOS
  end

  test do
    ENV["WLP_USER_DIR"] = testpath

    begin
      system bin/"wlp-webprofile10", "start"
      assert_path_exists testpath/"servers/.pid/defaultServer.pid"
    ensure
      system bin/"wlp-webprofile10", "stop"
    end

    refute_path_exists testpath/"servers/.pid/defaultServer.pid"
    assert_match "<feature>webProfile-10.0</feature>", (testpath/"servers/defaultServer/server.xml").read
  end
end
