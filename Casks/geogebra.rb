cask "geogebra" do
  version "6.0.933.1"
  sha256 "419b82b633dafdbc354cd73a8ccd5c260b69c66bb3df183615449665ac57dad2"

  url "https://download.geogebra.org/installers/#{version.major_minor}/GeoGebra-Classic-#{version.major}-MacOS-Portable-#{version.dots_to_hyphens}.zip"
  name "GeoGebra"
  desc "Solve, save and share math problems, graph functions, etc"
  homepage "https://www.geogebra.org/"

  livecheck do
    url "https://download.geogebra.org/package/mac-port"
    regex(%r{[^/]+?v?(\d+(?:[.-]\d+)+)[^/]+?$}i)
    strategy :header_match do |headers, regex|
      match = headers["location"]&.match(regex)
      next if match.blank?

      match[1].tr("-", ".")
    end
  end

  depends_on macos: :monterey

  app "GeoGebra Classic #{version.major}.app"

  uninstall quit:       "org.geogebra.mathapps",
            login_item: "GeoGebra",
            pkgutil:    "org.geogebra#{version.major}.mac"

  zap trash: [
    "~/Library/Application Scripts/org.geogebra#{version.major}.mac",
    "~/Library/Application Scripts/W5S878FTRC.org.geogebra#{version.major}.mac",
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/org.geogebra#{version.major}.mac.sfl*",
    "~/Library/Containers/org.geogebra#{version.major}.mac",
    "~/Library/GeoGebra",
    "~/Library/Group Containers/W5S878FTRC.org.geogebra#{version.major}.mac",
    "~/Library/Preferences/org.geogebra.mathapps.helper.plist",
    "~/Library/Preferences/org.geogebra.mathapps.plist",
    "~/Library/Saved Application State/org.geogebra.mathapps.savedState",
  ]

  caveats <<~EOS
    #{token} is not signed by an identified developer, so macOS Gatekeeper
    blocks its first launch after every install or upgrade. Either allow it in:
      System Settings → Privacy & Security → Open Anyway
    or remove the quarantine attribute:
      xattr -dr com.apple.quarantine "#{appdir}/GeoGebra Classic #{version.major}.app"
  EOS
end
