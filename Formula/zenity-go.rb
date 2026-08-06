class ZenityGo < Formula
  desc "Zenity dialogs for Golang, Windows, macOS"
  homepage "https://pkg.go.dev/github.com/ncruces/zenity"
  url "https://github.com/ncruces/zenity/archive/refs/tags/v0.10.15.tar.gz"
  sha256 "ed900c7f0a16976fa57c06000f4a9e06e65dce669a475f54d52ddc2b77027e24"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "fd39b7108566d2afc87e22f1a4e6642b8ced365c72b2f4f3b94d8ab79c131390"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "d4027fdb783b8a4fdc16d81716f92bc7fce049baa33441d5c3e1839310cd3641"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "03927ab11ef0cc4ae50345322a682bd10e6be30743d605c68c8fbafc64c8dcdf"
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
