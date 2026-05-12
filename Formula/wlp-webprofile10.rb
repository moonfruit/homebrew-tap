class WlpWebprofile10 < Formula
  desc "Jakarta EE and MicroProfile application server (Jakarta EE Web Profile 10)"
  homepage "https://www.ibm.com/cloud/websphere-liberty"
  url "https://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/wasdev/downloads/wlp/26.0.0.4/wlp-webProfile10-26.0.0.4.zip"
  sha256 "75513ac857a4e0810415a454ee175f6a594e1842ff235c0096f7b34b4e03e104"

  livecheck do
    url "https://www.ibm.com/support/pages/websphere-liberty-developers"
    regex(/wlp-webProfile10[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "1c944480b01fc27a9e471bcb655479c61a7bb601b2f3b379ad895709fc8d8355"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "3596b519f95d80b020573b8dd131f07f36b82b1e221bfe268c3f85abe5b4649d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4afd3a5ba2375281450eeaa9734774c62581d97075c76ffcbac03747ce442cd6"
  end

  depends_on "openjdk"

  def install
    rm Dir["bin/**/*.bat"]

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
