class GaAgentCli < Formula
  desc "Agent-native command-line interface for Google Analytics 4"
  homepage "https://github.com/sajal2692/ga-cli"
  url "https://files.pythonhosted.org/packages/ca/33/8903c976d8a01775787b5e28e4fd318bbe06148df49fba3b71defcc07c40/ga_agent_cli-1.0.0.tar.gz"
  sha256 "5459902b92eaee1b4fd7fdef729547569c913ad108bbeaa267fe4a7d22254c89"
  license "MIT"

  # The Google Analytics clients pull grpcio, which compiles slowly (and often
  # fails) from source under virtualenv_install_with_resources. Install the
  # released wheel set into a private venv with uv instead.
  depends_on "python@3.13"
  depends_on "uv"

  def install
    venv = libexec
    python = formula_opt_bin("python@3.13")/"python3.13"
    system "uv", "venv", "--python", python, venv
    system "uv", "pip", "install", "--python", venv/"bin/python",
           "--no-cache", "ga-agent-cli==#{version}"
    bin.install_symlink venv/"bin/ga"
  end

  def caveats
    "Install the Claude Code skill with: ga skill install"
  end

  test do
    assert_match "ga, version #{version}", shell_output("#{bin}/ga --version")
    assert_match "Google Analytics", shell_output("#{bin}/ga --help")
  end
end
