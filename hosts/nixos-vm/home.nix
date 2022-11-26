{ pkgs, ... }:

{
  #imports =
  #  [
  #    #../../modules/desktop/bspwm/home.nix    # Window Manager
  #    ../../modules/desktop/hyprland/home.nix  # Window Manager
  #  ];

  home = {                                # Specific packages for desktop
    packages = with pkgs; [
      # Applications
      discord          # Comms
      ffmpeg           # Video Support
      firefox          # Browser
      gimp             # Graphical Editor
      handbrake        # Encoder
      inkscape         # Vector Graphical Editor
      libreoffice      # Office Packages
    ];
  };

  programs.zsh = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      trash = "gio trash";
      update = "cd /home/ole/.setup && nix flake update --commit-lock-file && cd -";
      upgrade = "sudo nixos-rebuild switch --flake /home/ole/.setup#nixos-vm";
    };
    history = {
      size = 100000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
    ohMyZsh = {
      enable = true;
      plugins = [ "git" "colored-man-pages" "zsh-autosuggestions" "zsh-syntax-highlighting" ];
      theme = "robbyrussell";
    };
  };
}
