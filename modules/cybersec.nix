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
  '';
}
