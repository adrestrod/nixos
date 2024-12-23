{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  name = "cybersecurity-env";

  buildInputs = [
    # General tools
    pkgs.git
    pkgs.curl
    pkgs.wget
    pkgs.tmux
    pkgs.vim

    # Malware reversing
    pkgs.radare2
    pkgs.ghidra
    pkgs.gdb
    pkgs.volatility
    pkgs.imhex

    # Web pentesting
    pkgs.nmap
    pkgs.sqlmap
    pkgs.nikto
    pkgs.gobuster
    pkgs.burpsuite

    # OSINT tools
    pkgs.theHarvester
    pkgs.recon-ng
    pkgs.maltego
    pkgs.metagoofil

    # Python and Node.js for scripting
    pkgs.python3
    pkgs.python3Packages.pip
    pkgs.nodejs

    # Optional: Docker for containerized tools
    pkgs.docker

    # Mullvad VPN
    pkgs.mullvad-vpn
  ];

  shellHook = ''
    echo "Welcome to the Cybersecurity Environment!"
    echo "Tools for malware reversing, pentesting, and OSINT are ready to use."

    # Configure and start Mullvad VPN
    if [ ! -f "$HOME/.config/mullvad-vpn/settings.json" ]; then
      mkdir -p $HOME/.config/mullvad-vpn
      ACCOUNT_NUMBER=$(grep '^MULLVAD_ACCOUNT=' .env | cut -d '=' -f2)
      echo "{"account":"$ACCOUNT_NUMBER","autostart":true}" > $HOME/.config/mullvad-vpn/settings.json
    fi

    echo "Starting Mullvad VPN..."
    mullvad-vpn &

    # Configure Git user details
    GIT_NAME=$(grep '^GIT_NAME=' .env | cut -d '=' -f2)
    GIT_EMAIL=$(grep '^GIT_EMAIL=' .env | cut -d '=' -f2)
    if [ -n "$GIT_NAME" ] && [ -n "$GIT_EMAIL" ]; then
      git config --global user.name "$GIT_NAME"
      git config --global user.email "$GIT_EMAIL"
      echo "Configured Git with name: $GIT_NAME and email: $GIT_EMAIL"
    else
      echo "Git configuration skipped. Missing GIT_NAME or GIT_EMAIL in .env file."
    fi

    # Configure SSH
    SSH_KEY=$(grep '^SSH_KEY=' .env | cut -d '=' -f2)
    if [ -n "$SSH_KEY" ]; then
      mkdir -p $HOME/.ssh
      echo "$SSH_KEY" > $HOME/.ssh/id_rsa
      chmod 600 $HOME/.ssh/id_rsa
      echo "SSH key configured."
    else
      echo "SSH key configuration skipped. Missing SSH_KEY in .env file."
    fi
  '';
}
