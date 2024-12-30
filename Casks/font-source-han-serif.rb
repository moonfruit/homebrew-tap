cask "font-source-han-serif" do
  version "2.003R"
  sha256 "6ee689ab57894ae35af604a73e95c372bda0306610ffa179a4708e8cd47a795f"

  url "https://github.com/adobe-fonts/source-han-serif/releases/download/#{version}/01_SourceHanSerif.ttc.zip"
  name "Source Han Serif"
  desc "OpenType Pan-CJK fonts"
  homepage "https://github.com/adobe-fonts/source-han-serif"

  font "SourceHanSerif.ttc"
end
