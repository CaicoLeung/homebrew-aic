class Aic < Formula
  desc "AI-powered git commit message generator"
  homepage "https://github.com/CaicoLeung/aic"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/CaicoLeung/aic/releases/download/v0.3.0/aic-aarch64-apple-darwin.tar.gz"
      sha256 "46f72179a70c8f5f5c0bf4605fc2a2e2b015a82dc4835e12bdc372ced3d03ea8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/CaicoLeung/aic/releases/download/v0.3.0/aic-x86_64-apple-darwin.tar.gz"
      sha256 "0b77f899e8db73753e80a440ab94b12840b4909561e4354f36541dd598e87cbe"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/CaicoLeung/aic/releases/download/v0.3.0/aic-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7ed4420e9583ce424860188c8f78f1135146a452ac84308999d7e242dc36a02d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/CaicoLeung/aic/releases/download/v0.3.0/aic-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "34b92949111ea0eb40b5327b5e0f315246d8fc37d617ba1b8e47ec40a5ff9f4a"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "aic" if OS.mac? && Hardware::CPU.arm?
    bin.install "aic" if OS.mac? && Hardware::CPU.intel?
    bin.install "aic" if OS.linux? && Hardware::CPU.arm?
    bin.install "aic" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
