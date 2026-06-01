class ZenityGo < Formula
  desc "Zenity dialogs for Golang, Windows, macOS"
  homepage "https://pkg.go.dev/github.com/ncruces/zenity"
  url "https://github.com/ncruces/zenity/archive/refs/tags/v0.10.14.tar.gz"
  sha256 "10ccfaa5e454048ee6383883f64e510ba98dd440c00e3951e5458a07052ee539"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "1235386780c23bf5f361e446cd9344d85032c682889cab58d375a06f63c81ccf"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "d5e093f3a53fc0823276830a1e07701fbe7397307ac7230be61e6594bbf3cf59"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0b8b2e23cbf0f5cff4b004469865529d230a8f5cf75573287923128dc02d2a0a"
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
