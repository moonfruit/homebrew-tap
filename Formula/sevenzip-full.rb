class SevenzipFull < Formula
  desc "7-Zip file archiver with RAR support"
  homepage "https://7-zip.org"
  url "https://github.com/ip7z/7zip/releases/download/26.04/7z2604-src.tar.xz"
  sha256 "9691944c0fe0d01bb49373a704fb983fd33bc98b1738695179dfbf99ac1734f6"
  license all_of: ["LGPL-2.1-or-later", "BSD-3-Clause", :cannot_represent]
  head "https://github.com/ip7z/7zip.git", branch: "main"

  livecheck do
    formula "sevenzip"
  end

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any, arm64_golden_gate: "6afd001939be760dc52253079ee4063129ec02576a2a14e37319109e120b91dc"
    sha256 cellar: :any, arm64_tahoe:       "e55e189255247961c2687f14355a77e8c160dff7c6b12169f1fd5ff1475160a6"
    sha256 cellar: :any, arm64_linux:       "1683fff58db61021258c15019f072a7e78c73a431afdeb2e1bdc39777988e9d7"
    sha256 cellar: :any, x86_64_linux:      "2f48e1a14a327a599f9a23a0d7cd52adff2297aae935465ae04cdc7cf3bb73cf"
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
