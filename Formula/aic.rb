class Aic < Formula
  desc "AI-powered git commit message generator"
  homepage "https://github.com/CaicoLeung/aic"
  version "0.5.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/CaicoLeung/aic/releases/download/v0.5.4/aic-aarch64-apple-darwin.tar.gz"
      sha256 "beddf0096669c61b54211c24d8167c1b457f7a26ba2565282abfaa9d55e6f58a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/CaicoLeung/aic/releases/download/v0.5.4/aic-x86_64-apple-darwin.tar.gz"
      sha256 "680cca4ce2c978bcaf42b77d4050cf963dcc1f6ab0a264468ed5ca6f96506fb5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/CaicoLeung/aic/releases/download/v0.5.4/aic-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6913659f939af05488b5048128cf9e42ce4fe5598d00c2c70ed39b32ed88f2ab"
    end
    if Hardware::CPU.intel?
      url "https://github.com/CaicoLeung/aic/releases/download/v0.5.4/aic-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "bb39382aa1ca52a276077c2aa1695c3f2cb63cc1f9eaf0a45fa328dd11604def"
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
