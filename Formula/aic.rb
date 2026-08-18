class Aic < Formula
  desc "AI-powered git commit message generator"
  homepage "https://github.com/CaicoLeung/aic"
  version "0.5.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/CaicoLeung/aic/releases/download/v0.5.5/aic-aarch64-apple-darwin.tar.gz"
      sha256 "fed3cbc40adbb8ba8cb955096b30f71171de8580b6220ed23048737357389482"
    end
    if Hardware::CPU.intel?
      url "https://github.com/CaicoLeung/aic/releases/download/v0.5.5/aic-x86_64-apple-darwin.tar.gz"
      sha256 "8f48779ca0c2d1956e99c5fea7dd7c3a546edceea1bc076730a6190d1ee75205"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/CaicoLeung/aic/releases/download/v0.5.5/aic-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "595f1b5ae63dff0e68913c0cd3e0694cab791d87dd84b99030cf7d22c1fa800f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/CaicoLeung/aic/releases/download/v0.5.5/aic-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a5d9f7d65c478b55fec43f36a193d4a1357e4f8596b4d1e74cb8007d4cc001f9"
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
