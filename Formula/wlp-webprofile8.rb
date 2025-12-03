class WlpWebprofile8 < Formula
  desc "Jakarta EE and MicroProfile application server (Jakarta EE Web Profile 8)"
  homepage "https://www.ibm.com/cloud/websphere-liberty"
  url "https://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/wasdev/downloads/wlp/25.0.0.12/wlp-webProfile8-25.0.0.12.zip"
  sha256 "52e4e98e2071bf34c1fee06120b006fe28fd62485d460d35d2f161c1fb2d2852"

  livecheck do
    url "https://www.ibm.com/support/pages/websphere-liberty-developers"
    regex(/wlp-webProfile8[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  depends_on "openjdk"

  def install
    rm Dir["bin/**/*.bat"]

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
      assert_path_exists testpath/"servers/.pid/defaultServer.pid"
    ensure
      system bin/"wlp-webprofile8", "stop"
    end

    refute_path_exists testpath/"servers/.pid/defaultServer.pid"
    assert_match "<feature>webProfile-8.0</feature>", (testpath/"servers/defaultServer/server.xml").read
  end
end
