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

      # GNOME extensions
      gnomeExtensions.dash-to-dock
      gnomeExtensions.gsconnect
    ];
  };

  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [
        "firefox.desktop"
        "org.gnome.Nautilus.desktop"
        "org.gnome.Console.desktop"
      ];
      enabled-extensions = [
        "dash-to-dock@micxgx.gmail.com"
      ];
    };
    "org/gnome/shell/extensions/dash-to-dock" = {
      dock-position = "LEFT";
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
    "org/gnome/desktop/sounds" = {
      event-sounds = "false";
    };
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    history = {
      expireDuplicatesFirst = true;
      ignoreDups = true;
      save = 100000;
      size = 100000;
    };
    shellAliases = {
      ll = "ls -l";
      trash = "gio trash";
      update = "cd /home/ole/.system && nix flake update --commit-lock-file && cd -";
      upgrade = "sudo nixos-rebuild switch --flake /home/ole/.system#nixos-vm";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "colored-man-pages" "history" "command-not-found" ];
      theme = "robbyrussell";
    };
  };

  programs.git = {
    enable = true;
    userName  = "ole";
    userEmail = "gitlab+account@ole.mn";
  };
}
