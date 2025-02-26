class WlpWebprofile8 < Formula
  desc "Jakarta EE and MicroProfile application server (Jakarta EE Web Profile 8)"
  homepage "https://www.ibm.com/cloud/websphere-liberty"
  url "https://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/wasdev/downloads/wlp/25.0.0.2/wlp-webProfile8-25.0.0.2.zip"
  sha256 "53c9a61816cb02c3426713d4b2a20179aa7e151bc171dec28e97133c4a938e30"

  livecheck do
    url "https://www.ibm.com/support/pages/websphere-liberty-developers"
    regex(/wlp-webProfile8[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  depends_on "openjdk"

  def install
    rm Dir["bin/**/*.bat"]

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
      assert_path_exists testpath/"servers/.pid/defaultServer.pid"
    ensure
      system bin/"wlp-webprofile8", "stop"
    end

    refute_path_exists testpath/"servers/.pid/defaultServer.pid"
    assert_match "<feature>webProfile-8.0</feature>", (testpath/"servers/defaultServer/server.xml").read
  end
end
