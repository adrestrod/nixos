{
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
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
    pkgs.volatility3
    pkgs.imhex

    # Web pentesting
    pkgs.nmap
    pkgs.sqlmap
    pkgs.nikto
    pkgs.gobuster
    pkgs.burpsuite

    # OSINT tools
    pkgs.theharvester
    pkgs.maltego
    pkgs.exiftool

    # Python and Node.js for scripting
    pkgs.python3Full
    pkgs.nodejs

    # Optional: Docker for containerized tools
    pkgs.docker

    # Mullvad VPN
    pkgs.mullvad-vpn
  ];
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "volatility3"
    ];
}
