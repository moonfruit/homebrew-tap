class P7zipFull < Formula
  desc "7-Zip (high compression file archiver) implementation"
  homepage "https://github.com/p7zip-project/p7zip"
  url "https://github.com/p7zip-project/p7zip/archive/refs/tags/v17.06.tar.gz"
  sha256 "c35640020e8f044b425d9c18e1808ff9206dc7caf77c9720f57eb0849d714cd1"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]

  livecheck do
    formula "p7zip"
  end

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2922f126182f5539c8287683ffcf926917fb0a97a1ff7c05398057be74243b82"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "34fccdf777698c3f40eb92fda4c675c84a29061c4c1bae402041d0bc561715f7"
    sha256 cellar: :any,                 arm64_linux:       "07c1ea2b6f3eb7b2f735433ec773b6000191e78aee4d089704629cae214520ea"
    sha256 cellar: :any,                 x86_64_linux:      "fef113d45320efee705b24564a92ff1300e7617e16e43b250f7eda355baaaba2"
  end

  keg_only :versioned_formula

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
