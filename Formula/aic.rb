class Aic < Formula
  desc "AI-powered git commit message generator"
  homepage "https://github.com/CaicoLeung/aic"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/CaicoLeung/aic/releases/download/v0.2.1/aic-aarch64-apple-darwin.tar.gz"
      sha256 "209742261801c8137297ab703b588920c107f9e479352587317403b83f2235f7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/CaicoLeung/aic/releases/download/v0.2.1/aic-x86_64-apple-darwin.tar.gz"
      sha256 "22deebd0278b120da5f6e5d6e3f43e9987b5cea87e45e4d486d6cfaf1026b7ea"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/CaicoLeung/aic/releases/download/v0.2.1/aic-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "cd9d2f2a6c8ca978c26fe2e63d43510d1ef14b7ebe8af080bb757a8709f9f2e1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/CaicoLeung/aic/releases/download/v0.2.1/aic-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a0ad78ee24f95d021495689dbfae5b3610d6b03b2eeb78cb60f8822e75851b2f"
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
