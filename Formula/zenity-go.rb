class ZenityGo < Formula
  desc "Zenity dialogs for Golang, Windows, macOS"
  homepage "https://pkg.go.dev/github.com/ncruces/zenity"
  url "https://github.com/ncruces/zenity/archive/refs/tags/v0.10.14.tar.gz"
  sha256 "10ccfaa5e454048ee6383883f64e510ba98dd440c00e3951e5458a07052ee539"
  license "MIT"

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
