class WlpWebprofile8 < Formula
  desc "Jakarta EE and MicroProfile application server (Jakarta EE Web Profile 8)"
  homepage "https://www.ibm.com/cloud/websphere-liberty"
  url "https://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/wasdev/downloads/wlp/26.0.0.8/wlp-webProfile8-26.0.0.8.zip"
  sha256 "a4ac8cdafcd0cfa4d41c61ec4f74c91f8e3f52e8cf0530f966bad3ef27d2d70f"

  livecheck do
    url "https://www.ibm.com/support/pages/websphere-liberty-developers"
    regex(/wlp-webProfile8[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "d9f1422788b515ddd960f55fcc2055bd83ae9049df18e27f68ed38620fdf4dde"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "6cba7299e9026ea9a64267efbf2588b2c8b7c2d5633a8ad3ad980e6504b97173"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1366c2dd9db3ca32da3f6aedde444692e152c67216ff2b98129d22d450af637f"
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
    pid_file = testpath/"servers/.pid/defaultServer.pid"
    messages_log = testpath/"servers/defaultServer/logs/messages.log"

    begin
      system bin/"wlp-webprofile8", "start"
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
      quiet_system bin/"wlp-webprofile8", "stop"
    end

    assert_match "<feature>webProfile-8.0</feature>", (testpath/"servers/defaultServer/server.xml").read
  end
end
