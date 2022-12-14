class Amber < Formula
  desc "Search and replace tool written by Rust"
  homepage "https://github.com/dalance/amber"
  url "https://github.com/dalance/amber/archive/refs/tags/v0.5.9.tar.gz"
  sha256 "bf974e997fffa0d54463fc85e44f054563372ca4dade50099fb6ecec0ca8c483"
  license "MIT"
  head "https://github.com/dalance/amber.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "false"
  end
end
