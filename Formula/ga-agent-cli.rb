class GaAgentCli < Formula
  desc "Agent-native command-line interface for Google Analytics 4"
  homepage "https://github.com/sajal2692/ga-cli"
  url "https://files.pythonhosted.org/packages/a1/dc/d847ec6ad821054e19258c5f8fbf936b6bec66b01f4bedd62a1e5b646302/ga_agent_cli-1.0.1.tar.gz"
  sha256 "402e4a4acbc3d47a0f5b8f88402318068f99f5583eed38eba17665f487b1931c"
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
    bin.install_symlink venv/"bin/ga4"
  end

  def caveats
    "Install the Claude Code skill with: ga4 skill install"
  end

  test do
    assert_match "ga4, version #{version}", shell_output("#{bin}/ga4 --version")
    assert_match "Google Analytics", shell_output("#{bin}/ga4 --help")
  end
end
