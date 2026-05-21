class Ethr < Formula
  desc "Comprehensive Network Measurement Tool for TCP, UDP & ICMP"
  homepage "https://github.com/microsoft/ethr"
  url "https://github.com/microsoft/ethr/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "c4bf9d6d4e0659f491b6de6d66ddfe3735d8f6fa791debe9e8bfe0aa0e93ddd3"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "9561789c7286f6bca21bd95b4e1bd724e8a90f67b4eb3360353045fbb71f0a09"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "815f9a182a8c1533f8c1a8b22b2e63d574f0d8822393ce84f423243697c07bb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "98aabebfd23c4e2f2053fc42887276fd3af2cdeb13572d88c44f217740cf768d"
  end

  depends_on "go" => :build

  # Upstream go.mod is missing golang.org/x/net dependency
  patch :DATA

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.gVersion=v#{version}")
  end

  test do
    assert_match "Version: v#{version}", shell_output("#{bin}/ethr -h")
  end
end

__END__
diff --git a/go.mod b/go.mod
index 1234567..abcdefg 100644
--- a/go.mod
+++ b/go.mod
@@ -3,7 +3,8 @@
 require (
 	github.com/mattn/go-runewidth v0.0.9
 	github.com/nsf/termbox-go v0.0.0-20200418040025-38ba6e5628f1
-	golang.org/x/sys v0.0.0-20200918174421-af09f7315aff
+	golang.org/x/net v0.53.0
+	golang.org/x/sys v0.43.0
 )

-go 1.13
+go 1.25.0
diff --git a/go.sum b/go.sum
index 1234567..abcdefg 100644
--- a/go.sum
+++ b/go.sum
@@ -2,5 +2,7 @@
 github.com/mattn/go-runewidth v0.0.9/go.mod h1:H031xJmbD/WCDINGzjvQ9THkh0rPKHF+m2gUSrubnMI=
 github.com/nsf/termbox-go v0.0.0-20200418040025-38ba6e5628f1 h1:lh3PyZvY+B9nFliSGTn5uFuqQQJGuNrD0MLCokv09ag=
 github.com/nsf/termbox-go v0.0.0-20200418040025-38ba6e5628f1/go.mod h1:IuKpRQcYE1Tfu+oAQqaLisqDeXgjyyltCfsaoYN18NQ=
-golang.org/x/sys v0.0.0-20200918174421-af09f7315aff h1:1CPUrky56AcgSpxz/KfgzQWzfG09u5YOL8MvPYBlrL8=
-golang.org/x/sys v0.0.0-20200918174421-af09f7315aff/go.mod h1:h1NjWce9XRLGQEsW7wpKNCjG9DtNlClVuFLEZdDNbEs=
+golang.org/x/net v0.53.0 h1:d+qAbo5L0orcWAr0a9JweQpjXF19LMXJE8Ey7hwOdUA=
+golang.org/x/net v0.53.0/go.mod h1:JvMuJH7rrdiCfbeHoo3fCQU24Lf5JJwT9W3sJFulfgs=
+golang.org/x/sys v0.43.0 h1:Rlag2XtaFTxp19wS8MXlJwTvoh8ArU6ezoyFsMyCTNI=
+golang.org/x/sys v0.43.0/go.mod h1:4GL1E5IUh+htKOUEOaiffhrAeqysfVGipDYzABqnCmw=
