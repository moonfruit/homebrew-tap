class SevenzipFull < Formula
  desc "7-Zip file archiver with RAR support"
  homepage "https://7-zip.org"
  url "https://github.com/ip7z/7zip/releases/download/26.06/7z2606-src.tar.xz"
  sha256 "a4e374c8f864f51df48c2cfd0e1413ec3b2ea030deae852d6a655402ebb61ac4"
  license all_of: ["LGPL-2.1-or-later", "BSD-3-Clause", :cannot_represent]
  head "https://github.com/ip7z/7zip.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any, arm64_golden_gate: "91c5b18e632e0535ee5f66fea62ebaac9c5cb617c07a3749adbf0bd9c66fd28b"
    sha256 cellar: :any, arm64_tahoe:       "350b0180ec62075ea65cbfe64d6be82cf7e34dec0a224ff4ba2dc53e20f97a3b"
    sha256 cellar: :any, arm64_linux:       "62808a1d63fbca11aa0115427d221f35130bf4a888bd72451672665b03bb5edb"
    sha256 cellar: :any, x86_64_linux:      "f0de45f7f3021ce0c70690f001c7357f74b57399e9d6814af5ca54bcda88fdac"
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
