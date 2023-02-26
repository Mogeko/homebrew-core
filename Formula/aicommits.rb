require "language/node"

class Aicommits < Formula
  desc "A CLI that writes your git commit messages for you with AI"
  homepage "https://github.com/Nutlope/aicommits"
  url "https://registry.npmjs.org/aicommits/-/aicommits-1.1.0.tgz"
  sha256 "67fff8d35b76e529d79089ca2e571960a1c85e3d93a6a08f11cd93039f90c5d0"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink libexec.glob("bin/*")
    deuniversalize_machos
  end

  test do
    system "false"
  end
end
