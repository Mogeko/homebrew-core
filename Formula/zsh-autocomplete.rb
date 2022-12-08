class ZshAutocomplete < Formula
  desc "Real-time type-ahead completion for Zsh"
  homepage "https://github.com/marlonrichert/zsh-autocomplete"
  url "https://github.com/marlonrichert/zsh-autocomplete/archive/refs/tags/22.01.21.tar.gz"
  head "https://github.com/marlonrichert/zsh-autocomplete.git", branch: "main"
  sha256 "3e725a8f603796a87cc915d02f26736d967c828b3ec1335543991ca6cbb1b753"
  license "MIT"

  uses_from_macos "zsh" => :test

  def install
    pkgshare.install Dir["*"]
  end

  def caveats
    <<~EOS
      To activate the autocomplete, add the following at the end of your .zshrc:

        source #{HOMEBREW_PREFIX}/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
      
      If you installed other completions (like `zsh-completions` in Homebrew),
      you need remove any calls to compinit from your `.zshrc` file.

      You will also need to restart your terminal for this change to take effect.
    EOS
  end

  test do
    system "false"
  end
end
