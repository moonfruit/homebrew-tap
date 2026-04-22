class GwtAT24 < Formula
  desc "Google web toolkit"
  homepage "https://www.gwtproject.org/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/google-web-toolkit/gwt-2.4.0.zip"
  sha256 "27d48a4b6df9de01eaf1bd3ba3971a8f32742886f67041ddc3cd9dbe01787ebf"
  license "Apache-2.0"

  keg_only :versioned_formula

  depends_on "openjdk"

  def install
    rm Dir["*.cmd", "*.dll"]
    libexec.install Dir["*"]

    (bin/"i18nCreator").write_env_script libexec/"i18nCreator", Language::Java.overridable_java_home_env
    (bin/"webAppCreator").write_env_script libexec/"webAppCreator", Language::Java.overridable_java_home_env
  end

  test do
    system bin/"webAppCreator", "sh.brew.test"
    assert_path_exists testpath/"src/sh/brew/test.gwt.xml"
  end
end
