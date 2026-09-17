class SevenzipFull < Formula
  desc "7-Zip file archiver with RAR support"
  homepage "https://7-zip.org"
  url "https://github.com/ip7z/7zip/releases/download/26.03/7z2603-src.tar.xz"
  sha256 "9cbde5099c6deb73691b0579063da5827522ccbbcba3f0020fd04e8c8c16c0d4"
  license all_of: ["LGPL-2.1-or-later", "BSD-3-Clause", :cannot_represent]
  head "https://github.com/ip7z/7zip.git", branch: "main"

  livecheck do
    formula "sevenzip"
  end

  conflicts_with "sevenzip", because: "both install `7zz` binaries"

  def install
    mac_suffix = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch
    mk_suffix, directory = if OS.mac?
      ["mac_#{mac_suffix}", "m_#{mac_suffix}"]
    else
      ["gcc", "g"]
    end
    cd "CPP/7zip/Bundles/Alone2" do
      system "make", "-f", "../../cmpl_#{mk_suffix}.mak"
      bin.install "b/#{directory}/7zz"
    end
    cd "CPP/7zip/Bundles/Format7zF" do
      system "make", "-f", "../../cmpl_#{mk_suffix}.mak"
      lib.install "b/#{directory}/7z.so"
      lib.install_symlink "7z.so" => shared_library("lib7z")
    end
  end

  test do
    (testpath/"foo.txt").write("hello world!\n")
    system bin/"7zz", "a", "-t7z", "foo.7z", "foo.txt"
    system bin/"7zz", "e", "foo.7z", "-oout"
    assert_equal "hello world!\n", (testpath/"out/foo.txt").read

    rar = "UmFyIRoHAQDz4YLrCwEFBwAGAQGAgIAAjwJVDRkCAp8ABIkEpIMCRlK0o4AFAQdiaWcudHh0x4EcJVQvsy3YVzN1Bw+" \
          "HA4t/jDAfZ+tOWDXPSpX8yB13VlEDBQQA"
    (testpath/"big.rar").binwrite(rar.unpack1("m"))
    system bin/"7zz", "e", "big.rar", "-oout"
    assert_equal "#{"hello world! " * 40}\n", (testpath/"out/big.txt").read
  end
end
