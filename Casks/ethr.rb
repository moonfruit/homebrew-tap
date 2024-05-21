cask "ethr" do
  version "1.0.0"
  sha256 "debbaf0dc4437d9d14f9de613abe58ca4074814f1f77345697e924bd29e9a47f"

  url "https://github.com/microsoft/ethr/releases/download/v#{version}/ethr_osx.zip"
  name "ethr"
  desc "Comprehensive Network Measurement Tool for TCP, UDP & ICMP"
  homepage "https://github.com/microsoft/ethr"

  binary "ethr"
end
