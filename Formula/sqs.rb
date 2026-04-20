class Sqs < Formula
  desc "Reorder lists from the terminal"
  homepage "https://github.com/dodgog/sqs"
  version "0.3.3"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/dodgog/sqs/releases/download/v0.3.3/sqs-aarch64-apple-darwin.tar.xz"
    sha256 "cd059bd6ab33ba4d866481250f6ff92a4bd0af3e200c1a50e63b99b7ef1023d5"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/dodgog/sqs/releases/download/v0.3.3/sqs-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "923d7d93346478d5de809ec9d9679531329326d5fb600a2761304a98cc192bf0"
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-unknown-linux-gnu": {},
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
    bin.install "sqs" if OS.mac? && Hardware::CPU.arm?
    bin.install "sqs" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
