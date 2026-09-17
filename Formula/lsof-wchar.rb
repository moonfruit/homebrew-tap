class LsofWchar < Formula
  desc "Utility to list open files with CJK/UTF-8 wide-char fix"
  homepage "https://github.com/lsof-org/lsof"
  url "https://github.com/lsof-org/lsof/archive/refs/tags/4.99.7.tar.gz"
  sha256 "bac1b0acbc50aede42fc97dffaa0b0475e97973e36a6351de5f349c6155afc68"
  license "lsof"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/moonfruit/bottle"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8608f0b9a3cd53449946e274e5f8b7b1ad028e26216cb75cea355018eb561701"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f11f9f4d260cc864334d85f899c09e20df2db745fa4f2b394dab1dcc1a92710b"
    sha256 cellar: :any,                 arm64_linux:       "578b95729afffd60fe77abfa43e95323802118343c27332943e6dbbf1163e729"
    sha256 cellar: :any,                 x86_64_linux:      "1923cb2944eb5beff366cd560620054a7a49498d85ae7a9efe3689e35bdff4d1"
  end

  on_linux do
    depends_on "groff" => :build
    depends_on "libtirpc"
  end

  conflicts_with "lsof", because: "both install `lsof` binaries"

  # Fix segfault when epoll fdinfo is unavailable, e.g. inside a container
  patch do
    url "https://github.com/lsof-org/lsof/commit/e1f8076051c1adb02fd7c1a4c824e8f373a1ab7a.patch?full_index=1"
    sha256 "dfa5eac284b77ebb932f1b7defaf9d6852e0f97a021dbe2d4e8ae6983f27031d"
    type :backport
    resolves "https://github.com/lsof-org/lsof/pull/368"
  end

  # Fix garbled multibyte (CJK/UTF-8) process names in the COMMAND column and
  # align the column by terminal display width (wcwidth):
  #   - enable WIDECHARINCL so <wchar.h>/wcwidth() is declared on Darwin
  #   - teach safestrlen()/safestrprtn() to handle printable multibyte chars
  #   - size/print the COMMAND and TASKCMD columns by East Asian display width
  patch :DATA

  def install
    if OS.mac?
      ENV["LSOF_INCLUDE"] = MacOS.sdk_path/"usr/include"
      soelim = "mandoc_soelim"

      # Source hardcodes full header paths at /usr/include
      inreplace "lib/dialects/darwin/machine.h", "/usr/include", MacOS.sdk_path/"usr/include"
    else
      ENV["LSOF_INCLUDE"] = HOMEBREW_PREFIX/"include"
      soelim = "soelim"
    end

    ENV["LSOF_CC"] = ENV.cc
    ENV["LSOF_CCV"] = ENV.cxx

    mv "00README", "README"
    system "./Configure", "-n", OS.kernel_name.downcase

    system "make"
    bin.install "lsof"
    (man8/"lsof.8").write Utils.safe_popen_read(soelim, "Lsof.8")
  end

  test do
    (testpath/"test").open("w") do
      system bin/"lsof", testpath/"test"
    end
  end
end

__END__
diff --git a/lib/dialects/darwin/machine.h b/lib/dialects/darwin/machine.h
index a67280f..db6ed09 100644
--- a/lib/dialects/darwin/machine.h
+++ b/lib/dialects/darwin/machine.h
@@ -405,7 +405,7 @@
 
 #    define HASSETLOCALE 1
 #    define HASWIDECHAR 1
-/* #define	WIDECHARINCL	<wchar.h>	*/
+#    define WIDECHARINCL <wchar.h>
 
 /*
  * HASSNODE is defined for those dialects that have snodes.
diff --git a/lib/misc.c b/lib/misc.c
index 996cee5..55a7f6b 100644
--- a/lib/misc.c
+++ b/lib/misc.c
@@ -1362,14 +1362,39 @@ int safestrlen(char *sp,  /* string pointer */
                            *	    1 (1) = add trailing NL
                            *	 1: 0 (0) = ' ' printable
                            *	    1 (2) = ' ' not printable
+                           *	 4: 0 (0) = byte width
+                           *	    1 (16) = East Asian display
+                           *		     width (wcwidth)
                            */
 {
     char c;
     int len = 0;
+    int lnc, sl;
+
+#if defined(HASWIDECHAR)
+    wchar_t w;
+    int wcmx = MB_CUR_MAX, cw;
+#else  /* !defined(HASWIDECHAR) */
+    static int wcmx = 1;
+#endif /* defined(HASWIDECHAR) */
 
     c = (flags & 2) ? ' ' : '\0';
     if (sp) {
-        for (; *sp; sp++) {
+        for (sl = strlen(sp); *sp; sp += lnc, sl -= lnc) {
+
+#if defined(HASWIDECHAR)
+            if (wcmx > 1 && (lnc = mblen(sp, sl)) > 1) {
+                if ((mbtowc(&w, sp, sl) == lnc) && iswprint(w)) {
+                    cw = (flags & 0x10) ? wcwidth(w) : lnc;
+                    if (cw < 0)
+                        cw = 1;
+                    len += cw;
+                } else
+                    len += 4 * lnc; /* each byte as "\x%02x" */
+                continue;
+            }
+#endif /* defined(HASWIDECHAR) */
+            lnc = 1;
             if (!isprint((unsigned char)*sp) || (*sp == '\\') || (*sp == c)) {
                 if ((*sp < 0x20) || ((unsigned char)*sp == 0xff) ||
                     (*sp == '\\'))
@@ -1479,16 +1504,52 @@ void safestrprtn(char *sp,  /* string to print pointer pointer */
                              *	 4: 0 (0) = print ending '\n'
                              *	    1 (8) = don't print ending
                              *		    '\n'
+                             *	 5: 0 (0) = byte width
+                             *	    1 (16) = East Asian display
+                             *		     width (wcwidth)
                              */
 {
     char c, *up;
     int cl, i;
+    int lnc, lnt, sl;
+
+#if defined(HASWIDECHAR)
+    wchar_t w;
+    int wcmx = MB_CUR_MAX;
+#else  /* !defined(HASWIDECHAR) */
+    static int wcmx = 1;
+#endif /* defined(HASWIDECHAR) */
 
     if (flags & 4)
         putc('"', fs);
     if (sp) {
         c = (flags & 2) ? ' ' : '\0';
-        for (i = 0; i < len && *sp; sp++) {
+        for (i = 0, sl = strlen(sp); i < len && *sp; sp += lnc, sl -= lnc) {
+
+#if defined(HASWIDECHAR)
+            if (wcmx > 1 && (lnc = mblen(sp, sl)) > 1) {
+                if ((mbtowc(&w, sp, sl) == lnc) && iswprint(w)) {
+                    int cw = (flags & 0x10) ? wcwidth(w) : lnc;
+                    if (cw < 0)
+                        cw = 1;
+                    if ((i + cw) > len)
+                        break;
+                    for (lnt = 0; lnt < lnc; lnt++)
+                        putc((int)*(sp + lnt), fs);
+                    i += cw;
+                } else {
+                    for (lnt = 0; lnt < lnc; lnt++) {
+                        up = safepup((unsigned int)*(sp + lnt), &cl);
+                        if ((i + cl) > len)
+                            break;
+                        fputs(up, fs);
+                        i += cl;
+                    }
+                }
+                continue;
+            }
+#endif /* defined(HASWIDECHAR) */
+            lnc = 1;
             if ((*sp != '\\') && isprint((unsigned char)*sp) && *sp != c) {
                 putc((int)(*sp & 0xff), fs);
                 i++;
diff --git a/src/print.c b/src/print.c
index 494f9eb..35a1556 100644
--- a/src/print.c
+++ b/src/print.c
@@ -717,13 +717,13 @@ void print_file(struct lsof_context *ctx) {
      */
     cp = Lp->cmd ? Lp->cmd : "(unknown)";
     if (!PrPass) {
-        len = safestrlen(cp, 2);
+        len = safestrlen(cp, 2 | 0x10); /* 0x10: East Asian display width */
         if (CmdLim && (len > CmdLim))
             len = CmdLim;
         if (len > CmdColW)
             CmdColW = len;
     } else
-        safestrprtn(cp, CmdColW, stdout, 2);
+        safestrprtn(cp, CmdColW, stdout, 2 | 0x10);
     /*
      * Size or print the process ID.
      */
@@ -740,7 +740,7 @@ void print_file(struct lsof_context *ctx) {
      */
     if (!PrPass) {
         if ((cp = Lp->tcmd)) {
-            len = safestrlen(cp, 2);
+            len = safestrlen(cp, 2 | 0x10); /* 0x10: East Asian display width */
             if (TaskCmdLim && (len > TaskCmdLim))
                 len = TaskCmdLim;
             if (len > TaskCmdColW)
@@ -763,7 +763,7 @@ void print_file(struct lsof_context *ctx) {
         if (TaskPrtCmd) {
             cp = Lp->tcmd ? Lp->tcmd : "";
             printf(" ");
-            safestrprtn(cp, TaskCmdColW, stdout, 2);
+            safestrprtn(cp, TaskCmdColW, stdout, 2 | 0x10);
         }
     }
 #endif /* defined(HASTASKS) */
