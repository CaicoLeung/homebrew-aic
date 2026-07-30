class Aic < Formula
  desc "AI-powered git commit message generator"
  homepage "https://github.com/CaicoLeung/aic"
  version "0.3.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/CaicoLeung/aic/releases/download/v0.3.6/aic-aarch64-apple-darwin.tar.gz"
      sha256 "805bc2e2d6385221ab1b7307b86e819627fb062e9e215ebc739b8a39483a7485"
    end
    if Hardware::CPU.intel?
      url "https://github.com/CaicoLeung/aic/releases/download/v0.3.6/aic-x86_64-apple-darwin.tar.gz"
      sha256 "4d9463f08f1efab52b0ae2533dec733e592427163f29a86e0571128852d08612"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/CaicoLeung/aic/releases/download/v0.3.6/aic-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "57d1f96e6f487652b5d2713ff36d7ccdf0d42c37287ed8ae05444f8e1a5676fe"
    end
    if Hardware::CPU.intel?
      url "https://github.com/CaicoLeung/aic/releases/download/v0.3.6/aic-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1cf1cfd12ddcbfaba15490134d7f04925304c667f54f6afc467d9c68b1cb5ce8"
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
