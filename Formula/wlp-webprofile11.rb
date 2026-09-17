class WlpWebprofile11 < Formula
  desc "Jakarta EE and MicroProfile application server (Jakarta EE Web Profile 11)"
  homepage "https://www.ibm.com/cloud/websphere-liberty"
  url "https://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/wasdev/downloads/wlp/26.0.0.9/wlp-webProfile11-26.0.0.9.zip"
  sha256 "aa431bf5283b933f2fdae90103113f1f3b3af09d12dca92ba616207d8c8a1654"

  livecheck do
    url "https://www.ibm.com/support/pages/websphere-liberty-developers"
    regex(/wlp-webProfile11[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    rebuild 2
  end

  depends_on "openjdk"

  def install
    rm Dir["bin/**/*.bat"]

    libexec.install Dir["*"]
    (bin/"wlp-webprofile11").write_env_script "#{libexec}/bin/server",
                                              Language::Java.overridable_java_home_env
  end

  def caveats
    <<~EOS
      The home of Websphere Liberty Jakarta EE Web Profile 11 is:
        #{opt_libexec}
    EOS
  end

  test do
    ENV["WLP_USER_DIR"] = testpath
    pid_file = testpath/"servers/.pid/defaultServer.pid"
    messages_log = testpath/"servers/defaultServer/logs/messages.log"

    begin
      system bin/"wlp-webprofile11", "start"
      assert_path_exists pid_file

      # `start` returns before the JVM is ready, so wait for the server-ready
      # message to confirm the server actually came up.
      60.times do
        break if messages_log.file? && messages_log.read.include?("CWWKF0011I")

        sleep 1
      end
      assert_match "CWWKF0011I", messages_log.read
    ensure
      # Best-effort shutdown only; `stop` can time out on slow CI machines
      # (CWWKE0968W) and must not fail the test.
      quiet_system bin/"wlp-webprofile11", "stop"
    end

    assert_match "<feature>webProfile-11.0</feature>", (testpath/"servers/defaultServer/server.xml").read
  end
end
