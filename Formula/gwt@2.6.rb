class GwtAT26 < Formula
  desc "Google web toolkit"
  homepage "https://www.gwtproject.org/"
  url "https://github.com/gwtproject/gwt/releases/download/2.6.1/gwt-2.6.1.zip"
  sha256 "36d6b3884f1b2bc58a3eb1f69b3185a0b574ec4ee56f1bf307ecbacfe7201b75"
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
