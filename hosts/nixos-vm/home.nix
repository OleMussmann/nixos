{ pkgs, lib, ... }:

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
      dconf2nix        # turn GNOME dconf settings to nix strings

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

    # Prevent screen timeout for VM
    "org/gnome/desktop/session" = {
      idle-delay = lib.hm.gvariant.mkUint32 0;
    };
    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-type = "nothing";
    };
  };

  programs.zsh = {
    enable = true;
    defaultKeymap = "viins";
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    history = {
      expireDuplicatesFirst = true;
      ignoreDups = true;
      extended = true;     # save timestamps
      save = 100000;
      size = 100000;
    };
    historySubstringSearch = {
      enable = true;
    };
    shellAliases = {
      ll = "ls -l";
      trash = "gio trash";
      update = "cd /home/ole/.system && nix flake update --commit-lock-file";
      upgrade = "sudo nixos-rebuild switch --flake /home/ole/.system#nixos-vm";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "colored-man-pages" "history" ];
      theme = "robbyrussell";
    };
  };

  programs.starship = {
    enable = true;
  };

  programs.git = {
    enable = true;
    userName  = "ole";
    userEmail = "gitlab+account@ole.mn";
  };
}
