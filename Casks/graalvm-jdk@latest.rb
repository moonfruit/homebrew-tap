cask "graalvm-jdk@latest" do
  version "25.3.4.1,25i3,25i3-25.0.4.1"
  sha256 "8411c28344f47726c433a2fbf0fa399c199531802d458a917d4a05b106043141"

  url "https://gds.oracle.com/download/graal/#{version.csv.second}/archive/graalvm-jdk-#{version.csv.third}_macos-aarch64_bin.tar.gz"
  name "GraalVM Java Development Kit"
  desc "GraalVM from Oracle"
  homepage "https://www.graalvm.org/"

  livecheck do
    url "https://www.oracle.com/a/tech/docs/graalvm-downloads.json"
    regex(%r{/graal/([^/]+)/archive/graalvm-jdk-(.+?)_macos-aarch64_bin}i)
    strategy :json do |json, regex|
      # Check all current Oracle GraalVM releases, including Innovation
      latest, release = json.values
                            .select { |category| category["Title"] == "Oracle GraalVM" }
                            .flat_map { |category| category["Releases"].to_a }
                            .max_by { |release_version, _| Version.new(release_version) }
      next if latest.blank?

      release_page = Homebrew::Livecheck::Strategy.page_content(
        URI.join("https://www.oracle.com/", release["JSON File"]).to_s,
      )
      match = release_page[:content]&.match(regex)
      next if match.blank?

      "#{latest},#{match[1]},#{match[2]}"
    end
  end

  depends_on arch: :arm64
  depends_on :macos

  # The archive contains a versioned directory with a numeric suffix that can't
  # be identified upstream, so we rename it something generic
  rename "graalvm-*", "graalvm-jdk"

  artifact "graalvm-jdk", target: "/Library/Java/JavaVirtualMachines/graalvm-latest.jdk"

  # No zap stanza required

  caveats do
    license "https://www.oracle.com/downloads/licenses/graal-free-license.html"
  end
end
