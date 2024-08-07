class Uv < Formula
  desc "Extremely fast Python package installer and resolver, written in Rust"
  homepage "https://github.com/astral-sh/uv"
  url "https://github.com/astral-sh/uv/archive/refs/tags/0.2.34.tar.gz"
  sha256 "b111d5f6c4958bab14a6c4e3c4a77dc576a900aa3ce48caf0c2269901df64652"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/astral-sh/uv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f3244a55c438dbd9e357027fc852722ee2aa5d0625e601980871f9b14e0ae56f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11029478b47a14462923c18f93323f285245f25e98e6f96ef4b1007fd22f542f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0501b7fcf5a834ce844ceeec07ad12a283e4185425d3ebb9d5637b12427ca0d"
    sha256 cellar: :any_skip_relocation, sonoma:         "9cd7acfc28ae623c3b4dfe22eecc42f8ac698dd9379bf9b82746ad5886c555ba"
    sha256 cellar: :any_skip_relocation, ventura:        "f95bf43a020b7eb5ca1ed4e5d7a4b3b14a0ee4db7b147717b2b0ce114e3143f2"
    sha256 cellar: :any_skip_relocation, monterey:       "2d853098f3e7ce6bd5684737c13b0f70aa299a5dc968b5fc180fd6e4c380e45c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75a1d04023b6ff96b92e1f5788030552d94cfa26d5a63a6f5e07390e408ac572"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  uses_from_macos "python" => :test
  uses_from_macos "xz"

  on_linux do
    # On macOS, bzip2-sys will use the bundled lib as it cannot find the system or brew lib.
    # We only ship bzip2.pc on Linux which bzip2-sys needs to find library.
    depends_on "bzip2"
  end

  def install
    ENV["UV_COMMIT_HASH"] = ENV["UV_COMMIT_SHORT_HASH"] = tap.user
    ENV["UV_COMMIT_DATE"] = time.strftime("%F")
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/uv")
    generate_completions_from_executable(bin/"uv", "generate-shell-completion")
  end

  test do
    (testpath/"requirements.in").write <<~EOS
      requests
    EOS

    compiled = shell_output("#{bin}/uv pip compile -q requirements.in")
    assert_match "This file was autogenerated by uv", compiled
    assert_match "# via requests", compiled

    assert_match "ruff 0.5.1", shell_output("#{bin}/uvx -q ruff@0.5.1 --version")
  end
end
