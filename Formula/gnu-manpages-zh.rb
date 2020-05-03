class GnuManpagesZh < Formula
  desc "Chinese Manual Pages for GNU toolchain"
  homepage "https://github.com/man-pages-zh/manpages-zh"
  url "https://github.com/man-pages-zh/manpages-zh/archive/v1.6.3.3.tar.gz"
  sha256 "4a3696114f1372157624b27c4f5bf65f67528fc81244b203d75737505156a211"
  head "https://github.com/man-pages-zh/manpages-zh.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "make" => :build
  depends_on "opencc" => :build
  depends_on "python" => :build
  depends_on "groff"

  def install
    args = %W[
      --prefix=#{prefix}
      --program-prefix=g
    ]
    system "autoreconf", "--install"
    system "./configure", *args
    system "make"
    system "make", "install"

    # Symlink all man pages into share/man/ without the 'g' prefix
    %w[man1 man2 man3 man4 man5 man7 man8].each do |man_num|
      manpage_filenames(man/"zh_CN/#{man_num}").each do |cmd|
        (share/"man/zh_CN/#{man_num}").install_symlink man/"zh_CN/#{man_num}/g#{cmd}" => cmd
      end
      manpage_filenames(man/"zh_TW/#{man_num}").each do |cmd|
        (share/"man/zh_TW/#{man_num}").install_symlink man/"zh_TW/#{man_num}/g#{cmd}" => cmd
      end
    end
  end

  def caveats
    <<~EOS
      This man pages designed for GNU toolchain, NOT the BSD toolchain

      All the man pages have been installed with the prefix "g".
      If you need to use these man pages with their normal names, you
      can add the "man" directory to your MANPATH from your bashrc like:

        MANPATH="#{share}/man:$MANPATH"

      If the man pages shows garbled character.
      Please install the latest version of "groff":

        brew install groff

      Then add the following content at the end of "/etc/man.conf":

        NROFF #{bin}/preconv -e UTF8 | #{bin}/nroff -Tutf8 -mandoc -c

    EOS
  end

  def manpage_filenames(dir)
    filenames = []
    dir.find do |path|
      next if path.directory? || path.basename.to_s == ".DS_Store"

      filenames << path.basename.to_s.sub(/^g/, "")
    end
    filenames.sort
  end

  test do
    ENV["PAGER"] = "cat"
    output = shell_output("man -M #{man}/zh_CN gtrue")
    assert_match homepage, output
  end
end
