class Delve < Formula
  desc "Debugger for the Go programming language"
  homepage "https://github.com/go-delve/delve"
  url "https://github.com/go-delve/delve/archive/v1.6.0.tar.gz"
  sha256 "a10a6fc40d87572c6d3f3becdb1a289269e17526d038749f2fa04dd9f591f26a"
  license "MIT"

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args, "-o", bin/"dlv", "./cmd/dlv"
  end

  test do
    (testpath/"hello.go").write <<~EOS
      package main

      import "fmt"

      func main() {
          output := "Hello World"
          fmt.Println(output)
      }
    EOS

    system "go", "mod", "init", "hello"

    output = pipe_output("#{bin}/dlv debug --allow-non-terminal-interactive=true",
                         "b hello.go:7\nc\np output\nexit\n")
    assert_match '"Hello World"', output.lines[-2]
  end
end
