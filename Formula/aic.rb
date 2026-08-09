class Aic < Formula
  desc "AI-powered git commit message generator"
  homepage "https://github.com/CaicoLeung/aic"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/CaicoLeung/aic/releases/download/v0.5.0/aic-aarch64-apple-darwin.tar.gz"
      sha256 "9acb9aac7eaaeb65f538f439bc92a9981003b581742a0707301215f1474c8b04"
    end
    if Hardware::CPU.intel?
      url "https://github.com/CaicoLeung/aic/releases/download/v0.5.0/aic-x86_64-apple-darwin.tar.gz"
      sha256 "573dba4c3d99c74cc62924e0e5c9cd5343058c2829806f23b99d6820be124c38"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/CaicoLeung/aic/releases/download/v0.5.0/aic-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "77dbafb72e658e293fa6f25914daded23e4c4686cfe619d8b7da2143f5c2143e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/CaicoLeung/aic/releases/download/v0.5.0/aic-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "bebc1ab4cfe0b9db29ff2f981b0f37f44cfd31839643e69d31dfe5b98cf9217e"
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
