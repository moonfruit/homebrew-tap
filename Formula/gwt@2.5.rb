class GwtAT25 < Formula
  desc "Google web toolkit"
  homepage "https://www.gwtproject.org/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/google-web-toolkit/gwt-2.5.1.zip"
  sha256 "c457df45a3eed582452c5784ed11746685df494c0ffe4a8ae4de52945916593a"
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
