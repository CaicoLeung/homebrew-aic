class Aic < Formula
  desc "AI-powered git commit message generator"
  homepage "https://github.com/CaicoLeung/aic"
  version "0.5.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/CaicoLeung/aic/releases/download/v0.5.6/aic-aarch64-apple-darwin.tar.gz"
      sha256 "fa5bf43bff35932058f4403a7a4879e6c24271ac2a3778b5bec16961a2594793"
    end
    if Hardware::CPU.intel?
      url "https://github.com/CaicoLeung/aic/releases/download/v0.5.6/aic-x86_64-apple-darwin.tar.gz"
      sha256 "d81289519ab43e727647d824bc4b03e159c8e773bcafec4d4e37615e0185e4d3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/CaicoLeung/aic/releases/download/v0.5.6/aic-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d49b872483a5ff61d1bd237b2d96319d3fa12428dcca882a7f50fe70211b26fc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/CaicoLeung/aic/releases/download/v0.5.6/aic-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4bcfebb3e54ca66fc1257ae793d4f37d35ba945ee5b9c4842013e0743940b6e1"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "arm-unknown-linux-gnueabihf":        {},
    "x86_64-apple-darwin":                {},
    "x86_64-pc-windows-gnu":              {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "aic"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "aic"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "aic"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "aic"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
