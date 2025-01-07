class P7zipAll < Formula
  desc "7-Zip (high compression file archiver) implementation"
  homepage "https://github.com/p7zip-project/p7zip"
  url "https://github.com/p7zip-project/p7zip/archive/refs/tags/v17.06.tar.gz"
  sha256 "c35640020e8f044b425d9c18e1808ff9206dc7caf77c9720f57eb0849d714cd1"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]

  conflicts_with "p7zip", because: "both install `7z` binary"

  def install
    if OS.mac?
      mv "makefile.macosx_llvm_64bits", "makefile.machine"
    else
      mv "makefile.linux_any_cpu", "makefile.machine"
    end
    system "make", "all3",
                   "CC=#{ENV.cc} $(ALLFLAGS)",
                   "CXX=#{ENV.cxx} $(ALLFLAGS)"
    system "make", "DEST_HOME=#{prefix}",
                   "DEST_MAN=#{man}",
                   "install"
  end

  test do
    (testpath/"foo.txt").write("hello world!\n")
    system bin/"7z", "a", "-t7z", "foo.7z", "foo.txt"
    system bin/"7z", "e", "foo.7z", "-oout"
    assert_equal "hello world!\n", File.read(testpath/"out/foo.txt")
  end
end
