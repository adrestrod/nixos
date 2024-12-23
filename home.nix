{
  pkgs,
  inputs,
  ...
}:
let
  # Convertir archivos estáticos en una lista explícita
  staticFiles = [
    {
      name = ".local/share/zsh/zsh-autosuggestions";
      value.source = "${pkgs.zsh-autosuggestions}/share/zsh/zsh-autosuggestions";
    }
    {
      name = ".local/share/zsh/zsh-syntax-highlighting";
      value.source = "${pkgs.zsh-syntax-highlighting}/share/zsh/site-functions";
    }
    {
      name = ".local/share/zsh/nix-zsh-completions";
      value.source = "${pkgs.nix-zsh-completions}/share/zsh/plugins/nix";
    }
    {
      name = ".zshrc";
      value.source = "${inputs.dotfiles}/zsh/.zshrc";
    }
    {
      name = ".config/kanshi/config";
      value.source = "${inputs.dotfiles}/kanshi/config";
    }
    # nvim config
    {
      name = ".config/nvim";
      value.source = "${inputs.dotfiles}/nvim";
    }
    # desktop config
    {
      name = ".config/waybar";
      value.source = "${inputs.dotfiles}/waybar";
    }
    {
      name = ".config/hypr";
      value.source = "${inputs.dotfiles}/hypr";
    }
    {
      name = "wallpapers";
      value.source = "${inputs.dotfiles}/wallpapers";
    }
    # tmux config
    {
      name = ".tmux.conf";
      value.source = "${inputs.dotfiles}/tmux/.tmux.conf";
    }
    {
      name = "/.tmux/plugins/tpm";
      value.source = "${inputs.tpm}";
    }
  ];

  # Define generatedFiles as an empty list if not defined elsewhere
  generatedFiles = [];
in {
  programs.home-manager.enable = true;
  programs.kitty = {
    enable = true;
    settings = {
      map = ''
        ctrl+shift+u no_op
      '';
      confirm_os_window_close = 0;
    };
  };
  home.username = "haru";
  home.homeDirectory = "/home/haru";
  home.stateVersion = "24.05";

  # Git config
  programs.git = {
    enable = true;
    extraConfig = {
      credential.helper = "${
        pkgs.git.override {withLibsecret = true;}
      }/bin/git-credential-libsecret";
      push = {autoSetupRemote = true;};
    };
  };

  # Concatenar las listas de archivos estáticos y generados
  home.file = builtins.listToAttrs (staticFiles ++ generatedFiles);
}
