class Aic < Formula
  desc "AI-powered git commit message generator"
  homepage "https://github.com/CaicoLeung/aic"
  version "0.5.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/CaicoLeung/aic/releases/download/v0.5.1/aic-aarch64-apple-darwin.tar.gz"
      sha256 "f1eaa8e80013c48b5f04aad0b3e3f48f08108b6df303719e29ccc6c71de77da2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/CaicoLeung/aic/releases/download/v0.5.1/aic-x86_64-apple-darwin.tar.gz"
      sha256 "9b666c7beaa88cde5df6f9b3e45cfc229f6bfcfc66e8a0ecab91cf5a9fb1ddcb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/CaicoLeung/aic/releases/download/v0.5.1/aic-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "cd7e37be8ec0fc8c66dc3db94052a50c68295cda0484478f6e7573c8db0e60a0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/CaicoLeung/aic/releases/download/v0.5.1/aic-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c45b1c8ec38f1e8317f0c2c9bf7d34982df699b3ebe060c92f0b67c58275a423"
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
