class Ethr < Formula
  desc "Comprehensive Network Measurement Tool for TCP, UDP & ICMP"
  homepage "https://github.com/microsoft/ethr"
  url "https://github.com/microsoft/ethr/releases/download/v1.0.0/ethr_osx.zip"
  sha256 "debbaf0dc4437d9d14f9de613abe58ca4074814f1f77345697e924bd29e9a47f"
  license "MIT"

  def install
    bin.install "ethr"
  end

  test do
    port = free_port
    fork do
      exec "#{bin}/ethr -s -port #{port}"
    end
    sleep 1
    system "#{bin}/ethr", "-d", "1s", "-c", "127.0.0.1", "-port", port

    assert_match '"Type":"TestResult"', File.read(testpath/"ethrc.log")
  end
end
