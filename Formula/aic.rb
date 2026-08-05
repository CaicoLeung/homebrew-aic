class Aic < Formula
  desc "AI-powered git commit message generator"
  homepage "https://github.com/CaicoLeung/aic"
  version "0.4.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/CaicoLeung/aic/releases/download/v0.4.6/aic-aarch64-apple-darwin.tar.gz"
      sha256 "b10cabeb74388a657b2b9e4121df7a9a292c216ac6c22f9b84db69afc818b2a5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/CaicoLeung/aic/releases/download/v0.4.6/aic-x86_64-apple-darwin.tar.gz"
      sha256 "290e5022bbd4d9a709f7ff77edbbc82ed328c89e2b243555eb4c7702cf7c91c8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/CaicoLeung/aic/releases/download/v0.4.6/aic-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "db28a92cf132f4c17c32fa62ddea9f1fe84588f7f86614dd6e2e253c820fe333"
    end
    if Hardware::CPU.intel?
      url "https://github.com/CaicoLeung/aic/releases/download/v0.4.6/aic-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9860c921cfc20470b499f3bf208c91b7484e001fc74c4ea45371f2454eb30301"
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
