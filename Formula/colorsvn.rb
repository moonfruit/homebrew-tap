class Colorsvn < Formula
  desc "Subversion output colorizer"
  homepage "https://web.archive.org/web/20170725092001/colorsvn.tigris.org/"
  url "https://web.archive.org/web/20170725092001/colorsvn.tigris.org/files/documents/4414/49311/colorsvn-0.3.3.tar.gz"
  sha256 "db58d5b8f60f6d4def14f8f102ff137b87401257680c1acf2bce5680b801394e"

  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/colorsvn/0.3.3.patch"
    sha256 "2fa2c40e90c04971865894933346f43fc1d85b8b4ba4f1c615a0b7ab0fea6f0a"
  end

  def install
    # `configure` uses `which` to find the `svn` binary that is then hard-coded
    # into the `colorsvn` binary and its configuration file. Unfortunately, this
    # picks up our SCM wrapper from `Library/ENV/` that is not supposed to be
    # used outside of our build process. Do the lookup ourselves to fix that.
    svn_binary = which_all("svn").reject do |bin|
      bin.to_s.start_with?("#{HOMEBREW_REPOSITORY}/Library/ENV/")
    end.first
    inreplace ["configure", "configure.in"], "\nORIGSVN=`which svn`",
                                             "\nORIGSVN=#{svn_binary}"

    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--sysconfdir=#{etc}"
    inreplace ["colorsvn.1", "colorsvn-original"], "/etc", etc
    system "make"
    system "make", "install"
  end

  def caveats
    <<~EOS
      You probably want to set an alias to svn in your bash profile.
      So source #{etc}/profile.d/colorsvn-env.sh or add the line

          alias svn=colorsvn

      to your bash profile.

      So when you type "svn" you'll run "colorsvn".
    EOS
  end

  test do
    assert_match "svn: E155007", shell_output("#{bin}/colorsvn info 2>&1", 1)
  end
end
