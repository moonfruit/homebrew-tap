class SevenzipFull < Formula
  desc "7-Zip file archiver with RAR support"
  homepage "https://7-zip.org"
  url "https://github.com/ip7z/7zip/releases/download/26.05/7z2605-src.tar.xz"
  sha256 "0b6080b8c3e7a579161d2d495224c0e51c467576cb4c7048b0ab485ef44cc22e"
  license all_of: ["LGPL-2.1-or-later", "BSD-3-Clause", :cannot_represent]
  head "https://github.com/ip7z/7zip.git", branch: "main"

  livecheck do
    formula "sevenzip"
  end

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any, arm64_golden_gate: "a2c5f9f122bf73cde58caf194d4b65eb9c76b1c9af4b91bf6933b07a2b14d81c"
    sha256 cellar: :any, arm64_tahoe:       "d4d89a779d8d8ea54ac7896eb50e0a40596eeb4f7f06ab82b56719f52e09dc8f"
    sha256 cellar: :any, arm64_linux:       "21945ed98344ac79fe79658d4ec9c39c5e701f41edb05c42919b1f52eeab2e2d"
    sha256 cellar: :any, x86_64_linux:      "c13ed29209f7d7fc3f83c3fb85a04a1590248d05b29d953cbad30cbd2008f2ff"
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
