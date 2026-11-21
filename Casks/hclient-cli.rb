cask "hclient-cli" do
  arch arm: "arm64", intel: "amd64"
  os macos: "darwin", linux: "linux"

  version "1.5.8"
  sha256 arm:          "dc03e404bbf4520c785aed5a3a4457f0f1ec0e6aae7a720eb9f800cd6b2c21f4",
         intel:        "0c338bb4b7453df1966d76552a9fbea0483132b4c366ffb4a29df0488f0fa465",
         arm64_linux:  "801f21bb6d82b94c99d26519c3a4faa82badd0731bc0fbe8c1411b96d7c78e0e",
         x86_64_linux: "343a6e43152e70f4f423492c8a205e0acb0de75af387606a84df32051674944d"

  url "https://dl.lazycatmicroserver.com/hclient-cli/v#{version}/hclient-cli-#{os}-#{arch}"
  name "hclient-cli"
  desc "Command-line client for LazyCat MicroServer"
  homepage "https://lazycat.cloud/download"

  livecheck do
    url "https://dl.lazycatmicroserver.com/hclient-cli/latest-version.json"
    strategy :json do |json|
      json["version"]&.delete_prefix("v")
    end
  end

  container type: :naked

  binary "hclient-cli-#{os}-#{arch}", target: "hclient-cli"
end
