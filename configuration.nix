{
  pkgs,
  meta,
  ...
}: {
    security.polkit.enable = true;
    # Add overlays
    nixpkgs = {
    # You can add overlays here
    overlays = [];
    config.allowUnfreePredicate = pkg: builtins.elem(lib.getName pkg) [
      "volatility3"
    ];
  };
  imports =
    [./machines/${meta.hostname}/configuration.nix];

  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  services.openssh.enable = true;
  services.mullvad-vpn.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set your time zone.
  time.timeZone = "Europe/Madrid";

  # Select internationalisation properties.
  i18n.defaultLocale = "es_ES.UTF-8";

  # user config
  users.users.haru = {
    isNormalUser = true;
    extraGroups = [
      "uinput"
      "wheel"
      "audio"
      "libvirtd"
    ];

    hashedPassword = "$6$p9bhKFOoSafPZoJk$SzAS3R760Th7uh1dbblFb5k7/k4g.cSW7fwCTKcbnmI8NZ6m11RfLp0i.jTSNclMeCQUSrLm6sr4ttNC8qOU..";
  };

  security.sudo.extraRules = [
    {
      users = ["haru"];
      commands = [
        {
          command = "ALL";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];

  environment.systemPackages = with pkgs; [
    cifs-utils
    age
    killall
  ];

  system.stateVersion = "24.11";
}
