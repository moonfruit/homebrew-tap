class GwtAT27 < Formula
  desc "Google web toolkit"
  homepage "https://www.gwtproject.org/"
  url "https://github.com/gwtproject/gwt/releases/download/2.7.0/gwt-2.7.0.zip"
  sha256 "aa65061b73836190410720bea422eb8e787680d7bc0c2b244ae6c9a0d24747b3"
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
