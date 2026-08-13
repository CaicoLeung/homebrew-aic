class Aic < Formula
  desc "AI-powered git commit message generator"
  homepage "https://github.com/CaicoLeung/aic"
  version "0.5.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/CaicoLeung/aic/releases/download/v0.5.2/aic-aarch64-apple-darwin.tar.gz"
      sha256 "e13cb893eaa2af1c80334da24440159bc4c20dfc0e6ff123745cf727c66db27b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/CaicoLeung/aic/releases/download/v0.5.2/aic-x86_64-apple-darwin.tar.gz"
      sha256 "8dc356dc652f4fab1b8505f4abd9d1c7fb2d60cfa9ede60def2a6676c127882c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/CaicoLeung/aic/releases/download/v0.5.2/aic-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0ec3a32e697cd8eb717de0a628fdb95c79e6b49a217a581097d734d858462a6a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/CaicoLeung/aic/releases/download/v0.5.2/aic-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "edc4c3c02dbd40969f9a994d63960b53b3e4a4cb8bc9b1708be8ba646ead4948"
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
