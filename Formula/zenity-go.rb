class ZenityGo < Formula
  desc "Zenity dialogs for Golang, Windows, macOS"
  homepage "https://pkg.go.dev/github.com/ncruces/zenity"
  url "https://github.com/ncruces/zenity/archive/refs/tags/v0.10.15.tar.gz"
  sha256 "ed900c7f0a16976fa57c06000f4a9e06e65dce669a475f54d52ddc2b77027e24"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c7c3a06f9088ad64d1c42c7575c83f4df6b9be3aafd9959614784dd154b40ee8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "52568e0d0f9236146813cb547fc7301093549209fc6fc0525897dcd78401f5e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a4f6caea491143ddd8d42c18099ef9505894976476913477bc49e652c1150b2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "70ad7c7f0994d04b3d2facff1f4c79b0abfb83fa8b5d285793138380370a4657"
  end

  depends_on "go" => :build

  conflicts_with "zenity", because: "both install `zenity` binaries"

  def install
    # The native Linux backend just shells out to the system `zenity`, so on
    # Linux build the Windows executable instead, for use under WSL. GOARCH is
    # left to follow the host, so amd64/arm64 map to the matching Windows arch.
    if OS.linux?
      ENV["GOOS"] = "windows"
      system "go", "build", *std_go_args(ldflags: "-s -w", output: libexec/"zenity.exe"), "./cmd/zenity"
      (bin/"zenity").write_env_script libexec/"zenity.exe", "--unixeol --wslpath", {}
    else
      system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"zenity"), "./cmd/zenity"
    end
  end

  test do
    # A Windows executable cannot run on a non-WSL Linux host, so just check it
    # was produced; macOS and WSL can actually drive a dialog.
    if OS.linux? && !OS.wsl?
      assert_path_exists libexec/"zenity.exe"
    else
      pipe_output "#{bin}/zenity --progress --auto-close"
    end
  end
end
